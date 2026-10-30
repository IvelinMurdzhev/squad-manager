@AGENTS.md

## Claude Code specifics
- Use plan mode for any change to `firestore.rules`, `storage.rules`, `functions/src/admin/**` or the data model, and wait for approval.
- Permissions and denials are in `.claude/settings.local.json` (local, not committed). Don't try to work around a denied command; ask the human.
- Skills live in `.claude/skills/`, mirrored from `.agents/skills/`. Keep both copies synchronized when changing a skill. In the owner's working copy, `.hq/tools/sync-claude-skills.sh` (or `.ps1` on Windows) regenerates the mirror.
- If a skill or AGENTS.md does not load, check `/context` (Memory files, Skills) and report it in STATUS.md when available, or tell the owner.
