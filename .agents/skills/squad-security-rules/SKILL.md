---
name: squad-security-rules
description: How to write, change and test Firestore and Storage Security Rules for Squad Manager, covering tenant isolation by membership, the role and permission checks, the active-user check, self-write limits and upload limits. Use whenever firestore.rules, storage.rules or rules-tests/ change, or when a feature fails with permission-denied.
---

# Squad Manager: security rules

Use together with the official `firestore-rules-creation` (authoring) and `firebase-security-rules-auditor` (audit) skills. This skill holds the project-specific model.

## Principles
- Deny by default. Every `match` block has explicit `allow` lines. No `allow read, write: if true`, and no time-based test rules.
- Never loosen a rule to make a feature work. Fix the data or the query instead, or move the write to a Cloud Function.
- Every change ships with tests in `rules-tests/` that cover allowed and denied cases. They run in the emulator.

## Helper functions (shape)
```
function signedIn() { return request.auth != null; }
function isAdmin() { return signedIn() && request.auth.token.platformAdmin == true; }
function membership(teamId) { return get(/databases/$(database)/documents/memberships/$(teamId + '_' + request.auth.uid)); }
function isMember(teamId) { return signedIn() && exists(/databases/$(database)/documents/memberships/$(teamId + '_' + request.auth.uid)) && membership(teamId).data.active == true; }
function roleIn(teamId, roles) { return isMember(teamId) && membership(teamId).data.role in roles; }
function can(teamId, perm) { return roleIn(teamId, ['owner']) || (roleIn(teamId, ['trainer']) && perm in membership(teamId).data.permissions); }
function onlyChanges(fields) { return request.resource.data.diff(resource.data).affectedKeys().hasOnly(fields); }
```
Keep the number of `get()`/`exists()` calls per request low (max 10 per rule evaluation, they are billed reads). Reuse helpers.

## Access matrix (v1)
| Path | Read | Write |
|---|---|---|
| `users/{uid}` | self, Admin, and teammates (limited public fields via a `publicProfile` doc if needed) | self, allow-listed fields only (`firstName,lastName,phone,photoPath,fcmTokens,consentAt`) |
| `organizations/{orgId}` | Admin, members of any team in org | Functions only |
| `teams/{teamId}` | members, Admin | Functions only |
| `memberships/{id}` | the member, members of the same team, Admin | Functions only |
| `teams/{t}/competitions`, `opponents`, `matches` | members | owner, or trainer with `edit_matches` |
| `…/matches/{m}/attendance/{uid}` | members | that member only (`uid == request.auth.uid`), fields `answer, reason, updatedAt`; reason required when `answer == 'no'` |
| `…/matches/{m}/lineup/current` | members | owner, trainer |
| `…/matches/{m}/events` | members | owner, or trainer with `enter_results` |
| `teams/{t}/stats` | members | Functions only |
| `teams/{t}/notifications` | owner, trainer with `send_notifications` | same |
| `contactRequests`, `mail`, `system/*` | Admin (system/health readable by Admin) | Functions only |

Inactive or deactivated users fail `isMember` because `active == false`. Token revocation is handled by Functions plus the client.

## Storage rules
- `users/{uid}/avatar.jpg`: write by self only, `request.resource.size < 5 * 1024 * 1024`, `contentType.matches('image/.*')`. Read by signed-in users.
- Crests: write by owner or Admin of that org/team (Storage rules can read Firestore with `firestore.get`), same size and type limits.

## Test checklist (rules-tests)
For each collection: unauthenticated denied · member of another team denied · inactive member denied · player cannot write role/permissions · player writes only own attendance · "no" without reason denied · trainer without permission denied · trainer with permission allowed · Admin allowed · oversized or non-image upload denied.
