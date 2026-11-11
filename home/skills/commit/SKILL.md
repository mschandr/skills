---
name: commit
description: Commit the current work with a clear message and a danger rating (None, Trivial, Low, Medium, High, Critical) for the change. Use whenever I ask to commit, make a commit, or save work to git. Optional argument - a hint for the message.
argument-hint: "[message hint]"
---

# Commit

Arguments: $ARGUMENTS

Invoking this skill is my explicit request to commit. Never push.

## 1. See what's changing
- `git status` and `git diff` (staged and unstaged), plus untracked files.
- If changes are already staged, commit only those. If nothing is staged, propose which files to stage,
  grouped by purpose. If the work contains unrelated changes, propose splitting it into separate commits.
- Never stage: .env files or anything that looks like a secret or key; large binaries or build output;
  files gitignored or generated. Flag them instead.

## 2. Rate the danger
- Read the danger scale: `.claude/shared/danger-levels.md` in the project if it exists, otherwise
`~/.claude/shared/danger-levels.md`. Classify each hunk, apply the escalation rules,
  and take the highest level as the commit's rating.
- This is a quick classification, not a full /blast-radius map. If the rating is High or Critical,
  or you're unsure between two levels, say so and offer to run /blast-radius --diff first.

## 3. Check before committing
- None or Trivial: no test run needed, unless the escalation rules apply (e.g. strings used in tests).
- Low or above: run the relevant tests (see the repo CLAUDE.md). If they fail, stop and report; don't commit.
- High: show the rating and reasons, and ask me to confirm before committing.
- Critical: stop. List the irreversible effects and the safeguards still missing (backup or restore path,
  dry run or affected-row count, rollback plan). Commit only after I explicitly confirm. Committing
  doesn't execute anything, but make it impossible to miss in the message.

## 4. Message format
Follow the repo's existing convention if it has one (check `git log --oneline -15`, e.g. Conventional
Commits). Otherwise:

```
<imperative summary, 72 characters max>

<why the change was made, and anything non-obvious about how; wrap at 72>

Danger: <None|Trivial|Low|Medium|High|Critical>
Danger-Reason: <one line: the deciding factor>
```

- For Critical, also add a first body line in capitals: `IRREVERSIBLE: <what>`.
- For --diff-style mixed commits, the trailer carries the highest level; list other notable hunks in the body.
- The trailers are machine-readable: `git log --grep="Danger: Critical"` finds every critical change.

## 5. Commit and report
- Show the final message and the files, then commit.
- Report: commit hash, files, danger level, tests run and results.
