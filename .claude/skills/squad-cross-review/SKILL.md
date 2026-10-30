---
name: squad-cross-review
description: Review a Squad Manager step branch, pull request or completed change when requested. Check spec fit, acceptance criteria, guardrails, security rules, tests and code quality, then report findings by severity.
---

When `.hq/` is available in the owner's working copy, use its referenced private material. On a public clone without `.hq/`, use tracked documentation and the user's request; if required product details or acceptance criteria are missing, ask before making a product decision.

# Squad Manager: cross-review

Review the changes independently against the requirements and available evidence. When practical, form an initial assessment before reading implementation notes.

## Inputs
- Branch `step/<id>-<slug>`. Diff with `git diff main...HEAD` and the commits with `git log main..HEAD --oneline`.
- ROADMAP step `<id>` (goal and acceptance criteria), the SPEC sections it references, AGENTS.md, the relevant `squad-*` skills.

## Procedure
1. **Verify, don't trust.** Check out the branch and run the Definition of Done commands yourself. Record real results.
2. **Spec fit.** For each acceptance criterion, mark met / partly met / not met, with file:line evidence.
3. **Guardrails.** Check for secrets or keys in the diff, writes to role/permission fields from the client, loosened rules, hard-coded strings or colors, prod project references, edits to third-party skills, and scope creep beyond the step.
4. **Security.** Check that rules changes have tests for both denied and allowed cases, that callables check auth, App Check and role first, and that no PII appears in logs.
5. **Quality.** Check layering (no Firebase calls in UI), stream disposal, error handling, naming, and dead code.
6. **UI.** Compare with `.hq/design/screens/` and confirm l10n keys exist.

## Output
When a persistent review is requested, write it to `.hq/progress/reviews/<id>-review.md` and summarize it in LOG.md:
```
Verdict: approve | approve with nits | changes required
Blocking (must fix): [file:line] issue → suggested fix
Important (should fix): …
Nits: …
Acceptance criteria: AC1 met · AC2 partly (why) · …
Commands run: … → results
```
Record the review state and next action in STATUS.md when requested. Report findings; make fixes only when the user asks for them.
