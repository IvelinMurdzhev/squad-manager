---
name: squad-cloud-functions
description: Conventions for Squad Manager Cloud Functions (TypeScript, 2nd gen, europe-west3), covering callable role checks, App Check, input validation, structured logging, secrets, idempotent triggers, scheduled jobs and testing with the emulator. Use for any change under functions/ or when adding a backend action.
---

# Squad Manager: Cloud Functions

## Setup
- TypeScript strict. Use the `firebase-functions` v2 API (`onCall`, `onDocumentWritten`, `onSchedule`, `onRequest`) and `firebase-admin`.
- Set global options once: `setGlobalOptions({ region: 'europe-west3', maxInstances: 5 })`. A low `maxInstances` caps runaway cost.
- Layout: `src/index.ts` (exports only), `src/admin/*` (role-protected callables), `src/triggers/*`, `src/scheduled/*`, `src/http/*` (health), `src/lib/` (auth guards, logging, validation, fcm, email).
- Validate inputs with `zod` (or equivalent). Reject unknown fields.

## Callable template
```ts
export const inviteMember = onCall({ enforceAppCheck: true }, async (req) => {
  const ctx = requireAuth(req);                    // throws 'unauthenticated'
  const input = InviteMemberInput.parse(req.data);  // throws 'invalid-argument'
  await requireOrgRole(ctx.uid, input.orgId, ['owner'], { allowAdmin: true }); // 'permission-denied'
  log.info('inviteMember', { uid: ctx.uid, orgId: input.orgId, teamId: input.teamId, requestId: ctx.requestId });
  // ...Admin SDK writes in a transaction/batch...
  return { ok: true };
});
```
- Admin check: `req.auth.token.platformAdmin === true`. Role checks read `memberships`.
- Throw `HttpsError` with stable codes. Messages are English. The client localizes them.

## Rules of the road
- Functions are the **only** writers of roles, permissions, `active`, counters, stats, `mail`, `contactRequests.status`.
- **Idempotent triggers**: recompute counters from source (or use event IDs) so retries don't double count.
- **Logging**: use `logger` from `firebase-functions` with structured fields `{function, uid, orgId, teamId, requestId}`. Never log emails, phones, names or tokens.
- **Secrets**: `defineSecret('SMTP_PASSWORD')` etc. Never hard-code a secret or put it in `.env` files in the repo.
- **Account flows**: `inviteMember` creates the Auth user without a password and sends the set-password link (Bulgarian template). `deactivateUser` sets `disabled`, calls `revokeRefreshTokens`, and marks memberships inactive.
- **Rate limit** `submitContactRequest`: max 3 per day per device/App Check token or IP hash. Store counters in a function-only collection.
- **Scheduling**: at most 3 Cloud Scheduler jobs in total (free tier). `dispatchScheduledNotifications` runs every 15 min, picks due items, and sends only to non-responders.
- **FCM**: use multicast, prune invalid tokens on `messaging/registration-token-not-registered`.
- **Health** (`onRequest`, GET only): checks Firestore read/write on `system/health`, Auth and Storage reachability, and the last scheduled run. Returns 200 or 503 with no data.

## Tests
- Unit-test the guards and validation (Jest/Vitest). Integration-test against the emulators (`firebase emulators:exec`). Never use real projects in tests.
- Each admin callable gets tests for: unauthenticated, wrong role, wrong org, valid admin, valid owner.

## Deploy
Agents never deploy to prod. Dev deploys run only on explicit human request: `firebase deploy --only functions --project squad-manager-dev`.
