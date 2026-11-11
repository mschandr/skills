# Working rules (global)

These apply in every repo. Each repo's own CLAUDE.md adds project facts; where they conflict, the repo wins.

## Approach
- Explore before editing: read the relevant files and say what you found in a few lines.
- For anything beyond a trivial change, give a short plan (files, tests), then proceed unless I stop you.
  For risky or ambiguous work, wait for my OK instead.
- Make the smallest change that fully solves the problem. No drive-by refactors.
- Follow the repo's existing patterns over your own preferences.
- When there's more than one reasonable approach, name the trade-off in one line and pick one.

## Verification
- For logic changes, write or update a failing test first, then make it pass.
- Run the relevant tests before saying you're done. Report results honestly, including failures.
- Never claim something works unless you've run it.

## Boundaries
- Don't add, upgrade or remove dependencies without asking.
- No destructive commands (rm -rf, git reset --hard, force push, dropping data) without asking.
- Don't commit unless I ask.
- Never read or modify .env files or secrets.

## Communication
- Be concise. Lead with the result.
- Finish each task with: files changed and why, test results, anything left open.
- If something is ambiguous, ask one question rather than guessing.

## Environment
- macOS or Debian, zsh, vim. Runtimes are managed by mise.
