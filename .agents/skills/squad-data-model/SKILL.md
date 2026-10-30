---
name: squad-data-model
description: Firestore data model rules for Squad Manager covering the multi-tenant hierarchy, collection paths, required fields, naming, indexes and how to evolve the model safely. Use when adding or changing collections, fields, queries or composite indexes, or Dart/TS models, or when writing .hq/DATA-MODEL.md.
---

When `.hq/` is available in the owner's working copy, use its referenced private material. On a public clone without `.hq/`, use tracked documentation and the user's request; if required product details or acceptance criteria are missing, ask before making a product decision.

# Squad Manager: data model

The authoritative description is `.hq/DATA-MODEL.md`, created in ROADMAP step 1.1 from SPEC §8. Keep it in sync with every change.

## Invariants (never break)
1. Hierarchy: `organizations` → `teams` → `teams/{teamId}/competitions` → `teams/{teamId}/matches` (match has `competitionId`).
2. Person↔team = `memberships/{teamId}_{uid}` with `role` (`owner|trainer|player`), `permissions: string[]`, `shirtNumber`, `position`, `active`, plus `orgId`, `teamId`, `uid`.
3. Every team-scoped document carries `orgId` and `teamId`, even when the path implies them. Rules and queries rely on that.
4. Admin is the Auth custom claim `platformAdmin`. Never add an `isAdmin` field.
5. `role`, `permissions`, `active`, counters and stats are written **only** by Cloud Functions (Admin SDK).
6. Players write only their own `attendance/{uid}` doc and their own `users/{uid}` profile fields (allow-list).
7. Matches and players keep `source` (`manual|integration`) and `externalIds` (map) for future imports.

## Conventions
- IDs: auto IDs, except composite keys `memberships/{teamId}_{uid}` and `stats/{compId}_{uid}`.
- Field names are lowerCamelCase in English. Timestamps are Firestore `Timestamp` (`createdAt`, `updatedAt` via server timestamp). Times are stored in UTC and shown in Europe/Sofia.
- Enums are lowercase strings: `format: '11x11'|'8x8'|'6x6'`, `type: 'league'|'cup'|'friendly'`, `answer: 'yes'|'maybe'|'no'`, `status: 'scheduled'|'played'|'cancelled'`.
- Search helpers are lowercase copies (`nameLower`) for prefix search.
- Storage paths mirror Firestore: `users/{uid}/avatar.jpg`, `organizations/{orgId}/crest.png`, `teams/{teamId}/crest.png`, `teams/{teamId}/opponents/{id}.png`.
- Denormalize small display data where reads would multiply (e.g. opponent name and crest path on the match). Document every denormalized field and the function that keeps it fresh.

## Queries and indexes
- "My teams": `memberships where uid == me and active == true`.
- "Team players": `memberships where teamId == X and active == true orderBy shirtNumber`.
- Matches: `teams/{teamId}/matches where competitionId == C orderBy kickoffAt`; upcoming/past split by `kickoffAt` vs now.
- Every composite index goes in `firestore.indexes.json`, committed, never only created in the console.

## Changing the model
1. Update `.hq/DATA-MODEL.md` first (field, type, writer, readers, index).
2. Update Dart and TS models, rules and rules tests in the same branch.
3. Make additive changes only. Removing or renaming a field needs a migration note and human approval in STATUS.md.
4. Size check: keep documents small, and keep arrays that grow without bound in subcollections.
