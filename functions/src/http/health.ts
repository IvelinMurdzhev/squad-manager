import type { Request, Response } from 'express';
import { logger } from 'firebase-functions';

export interface HealthProbes {
  firestore: () => Promise<void>;
  auth: () => Promise<void>;
  storage: () => Promise<void>;
}

export interface HealthOptions {
  /** How long a probe result is reused. The endpoint is public, so this caps backend work. */
  cacheMs?: number;
  now?: () => number;
}

const DEFAULT_CACHE_MS = 30_000;

export function createHealthHandler(
  probes: HealthProbes,
  { cacheMs = DEFAULT_CACHE_MS, now = Date.now }: HealthOptions = {},
) {
  let cached: { ok: boolean; expiresAt: number } | undefined;
  let inFlight: Promise<boolean> | undefined;

  async function runProbes(): Promise<boolean> {
    const results = await Promise.allSettled([
      probes.firestore(),
      probes.auth(),
      probes.storage(),
    ]);
    const ok = results.every((result) => result.status === 'fulfilled');
    const context = { function: 'health', healthy: ok };
    if (ok) logger.info('Health check completed', context);
    else logger.error('Health check failed', context);
    cached = { ok, expiresAt: now() + cacheMs };
    return ok;
  }

  async function isHealthy(): Promise<boolean> {
    if (cached && now() < cached.expiresAt) return cached.ok;
    // Concurrent requests share one probe run.
    inFlight ??= runProbes().finally(() => {
      inFlight = undefined;
    });
    return inFlight;
  }

  return async (request: Request, response: Response): Promise<void> => {
    response.set('Cache-Control', 'no-store');
    // Uptime monitors commonly send HEAD; Express drops the body for it.
    if (request.method !== 'GET' && request.method !== 'HEAD') {
      response.set('Allow', 'GET, HEAD').status(405).end();
      return;
    }
    const ok = await isHealthy();
    response.status(ok ? 200 : 503).end();
  };
}
