# Squad Manager — project instructions

Shared instructions for the active coding agent and the project owner. `CLAUDE.md` imports this file.

## Project

Squad Manager is an invite-only football club management app. Flutter targets Android and web; Firebase provides authentication, data, storage, functions, messaging, App Check and hosting. The interface is Bulgarian; code and documentation are English.

## Start and scope

- In the owner's working copy, read `.hq/progress/STATUS.md`, the latest `.hq/progress/LOG.md` entry, and the current `.hq/ROADMAP.md` step. Read only the referenced SPEC, design and ADR material needed for that step.
- On a public clone where `.hq/` is absent, use `README.md`, `docs/` and the user's request. Do not assume private planning material exists.
- Work only on the current step. Apply its listed skills; `squad-*` skills contain project-specific procedures.
- If a product decision is unclear, stop and record the question in STATUS.md when available. Do not invent product requirements.

## Project rules

- Flutter UI uses views and view models; repositories/services own Firebase access. Follow the relevant `squad-*` skill for implementation details.
- Put user-facing Flutter strings in Bulgarian ARB files and use theme tokens. Never hand-edit generated files.
- Security Rules deny by default. Test rule changes. Clients never write roles or permissions; privileged writes go through guarded Cloud Functions.
- Use fake data in code, fixtures and logs. Log `uid`, never names, emails or phone numbers.
- Never read, print, create or commit secrets, service-account keys, `.env` files or signing keys. Keep them outside the workspace.
- Use emulators for development. Modify the dev Firebase project only on the owner's request. Production changes and deploys are human-only.
- Keep changes within the current step. Record unrelated ideas separately.

## Verify and record

Run the checks required by the step and applicable project skills. Before reporting completion, verify the acceptance criteria with fresh command output. In the owner's working copy, update STATUS.md and append the exact changes, checks and next action to LOG.md. Keep `.hq/` out of Git.

Use Conventional Commits when committing. Never push to `main`, force-push, rewrite shared history, or bypass hooks. Follow the repository's reviewed pull-request process when a remote is configured.

## Skills

Project skills are in `.agents/skills/squad-*` and mirrored in `.claude/skills/`. Third-party skills are vendored in those skill directories. Read a skill when its task applies; do not edit third-party skill content directly.