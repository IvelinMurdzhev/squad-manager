import express from 'express';
import type { Server } from 'node:http';
import { afterEach, describe, expect, it } from 'vitest';
import {
  createHealthHandler,
  type HealthOptions,
  type HealthProbes,
} from '../src/http/health';

const servers: Server[] = [];
afterEach(async () => {
  await Promise.all(
    servers.splice(0).map(
      (server) =>
        new Promise<void>((resolve, reject) => {
          server.close((error) => (error ? reject(error) : resolve()));
          server.closeAllConnections();
        }),
    ),
  );
});

// Probes are not cached across calls unless a test reuses one server.
async function serve(probes: HealthProbes, options: HealthOptions = {}) {
  const app = express();
  app.use(createHealthHandler(probes, options));
  const server = app.listen(0, '127.0.0.1');
  servers.push(server);
  await new Promise<void>((resolve) => server.once('listening', resolve));
  const address = server.address();
  if (!address || typeof address === 'string') throw new Error('No test port');
  return (method = 'GET') =>
    fetch(`http://127.0.0.1:${address.port}/`, { method });
}

async function request(
  probes: HealthProbes,
  method = 'GET',
  options: HealthOptions = {},
) {
  return (await serve(probes, options))(method);
}

function healthy(): HealthProbes {
  return {
    firestore: async () => {},
    auth: async () => {},
    storage: async () => {},
  };
}

describe('health HTTP contract', () => {
  it('returns an empty 200 after all three probes succeed', async () => {
    const completed = new Set<string>();
    const probes = Object.fromEntries(
      ['firestore', 'auth', 'storage'].map((name) => [
        name,
        async () => {
          completed.add(name);
        },
      ]),
    ) as unknown as HealthProbes;
    const response = await request(probes);
    expect(response.status).toBe(200);
    expect(await response.text()).toBe('');
    expect(completed).toEqual(new Set(['firestore', 'auth', 'storage']));
  });

  for (const dependency of ['firestore', 'auth', 'storage'] as const) {
    it(`returns an empty 503 when ${dependency} fails`, async () => {
      const probes = healthy();
      probes[dependency] = async () => {
        throw new Error('fake dependency failure');
      };
      const response = await request(probes);
      expect(response.status).toBe(503);
      expect(await response.text()).toBe('');
    });
  }

  for (const method of ['POST', 'PUT', 'DELETE', 'OPTIONS']) {
    it(`rejects ${method} without running probes`, async () => {
      let called = false;
      const probe = async () => {
        called = true;
      };
      const response = await request(
        { firestore: probe, auth: probe, storage: probe },
        method,
      );
      expect(response.status).toBe(405);
      expect(response.headers.get('allow')).toBe('GET, HEAD');
      expect(await response.text()).toBe('');
      expect(called).toBe(false);
    });
  }

  it('answers HEAD like GET with no body', async () => {
    const response = await request(healthy(), 'HEAD');
    expect(response.status).toBe(200);
    expect(await response.text()).toBe('');
  });
});

describe('health result caching', () => {
  function counting(): { probes: HealthProbes; calls: () => number } {
    let calls = 0;
    const probe = async () => {
      calls += 1;
    };
    return {
      probes: { firestore: probe, auth: probe, storage: probe },
      calls: () => calls,
    };
  }

  it('reuses a fresh result and probes again after it expires', async () => {
    let time = 1_000;
    const { probes, calls } = counting();
    const get = await serve(probes, { cacheMs: 5_000, now: () => time });
    await get();
    await get();
    expect(calls()).toBe(3); // one run of three probes
    time += 5_000;
    await get();
    expect(calls()).toBe(6);
  });

  it('shares one probe run between concurrent requests', async () => {
    let calls = 0;
    const slow = async () => {
      calls += 1;
      await new Promise((resolve) => setTimeout(resolve, 100));
    };
    const get = await serve(
      { firestore: slow, auth: slow, storage: slow },
      { cacheMs: 0 },
    );
    const responses = await Promise.all([get(), get(), get()]);
    expect(responses.map((response) => response.status)).toEqual([
      200, 200, 200,
    ]);
    expect(calls).toBe(3);
  });

  it('caches a failure for the same window', async () => {
    let time = 0;
    let failing = true;
    const probes: HealthProbes = {
      ...healthy(),
      firestore: async () => {
        if (failing) throw new Error('fake dependency failure');
      },
    };
    const get = await serve(probes, { cacheMs: 1_000, now: () => time });
    expect((await get()).status).toBe(503);
    failing = false;
    expect((await get()).status).toBe(503);
    time += 1_000;
    expect((await get()).status).toBe(200);
  });
});
