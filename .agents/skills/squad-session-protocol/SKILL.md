---
name: squad-session-protocol
description: Start-of-session and end-of-session routine for Squad Manager. Use at the start of a work session, before stopping, or when the user says "pick up", "continue" or "where are we".
---

When `.hq/` is available in the owner's working copy, use its referenced private material. On a public clone without `.hq/`, use tracked documentation and the user's request; if required product details or acceptance criteria are missing, ask before making a product decision.

# Squad session protocol

In the owner’s working copy, the current step and next action live in `.hq/progress/STATUS.md`; session history is in `.hq/progress/LOG.md`. These are private and never staged or committed. On a public clone without `.hq/`, follow `AGENTS.md` and use the scope and requirements provided by the user.

## Start of session
1. Run `git status`. Fetch from `origin` when it is configured and reachable. If no remote branch is available yet, continue from the local branch and record that in LOG.md. If the working tree is dirty and the changes are not yours, stop and ask.
2. If `.hq/` exists, read `.hq/progress/STATUS.md` and continue only when its next action matches the requested work. If another work session appears active, check with the owner before modifying the same files or branch. If `.hq/` is absent, use the task scope supplied by the user.
3. If available, read the newest entry in `.hq/progress/LOG.md`.
4. If available, open `.hq/ROADMAP.md` at the current step. Read its goal, prerequisites, references, skills and acceptance checks.
5. Read only the referenced SPEC/design sections and relevant ADRs when available. If required product detail is missing, ask before deciding.
6. Switch to `step/<id>-<slug>`. If it does not exist, create it from the latest `main` when available; in a fresh local repository without a remote main, create it from the current local branch. Never rewrite shared history.
7. Update STATUS.md with the active step and state = `in progress` (no commit; the file is untracked).
8. Before writing code, state a short plan (3–7 bullets) mapped to the acceptance criteria.

## During the session
- Commit small, logical units with Conventional Commits. Use an `Agent: <name>` trailer when required by the project workflow.
- An ambiguity in the spec goes into STATUS.md under "Open questions". Then stop, or continue on parts that don't depend on it.
- An idea outside the step goes into `.hq/progress/IDEAS.md`.

## End of session (always, even if unfinished)
1. Run the Definition of Done commands from AGENTS.md that apply to what you touched. Keep the real output.
2. Add a LOG.md entry at the top, using the template in that file. List the exact commands you ran and their results. Never write "tests pass" without having run them in this session.
3. Update STATUS.md: state (`in progress` / `ready for review` / `blocked`), next action and open questions.
4. Commit changes with Conventional Commits when the user or repository workflow requests a commit. Push only when explicitly authorized. Never `git add` anything under `.hq/`.
5. Tell the human in 2–3 lines: what's done and what the next action is.

## Handoff quality bar
A fresh agent with no chat history must be able to continue from STATUS.md + LOG.md (in `.hq/progress/`) + the branch alone. Reference files by path, don't paste code. Redact secrets and personal data.
