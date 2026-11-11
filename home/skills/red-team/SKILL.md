---
name: red-team
description: Adversarially attack a codebase to find real defects and prove each one with a failing test. Use when asked to red-team, attack, stress or try to break code. Default scope is the whole codebase (prioritized by hotspots); optional argument is a path to focus on, or --diff for only the current uncommitted change.
argument-hint: "[path | --diff]"
---

# Red team

Arguments: $ARGUMENTS

You coordinate; the `red-team` subagent attacks. Keep the attack in a fresh context so it isn't anchored
on how the code was built or explained.

## 1. Set the scope
- No argument: the whole codebase, prioritized by hotspots (see below).
- A path: that file or directory, in depth.
- `--diff`: only what `git diff` and untracked files show. Quick pre-merge check.

## 2. Gather context for the attacker (briefly)
- Read the project CLAUDE.md if it exists: commands, conventions, gotchas.
  If there isn't one, note the test command and test location yourself.
- If analyze-codebase listed hotspots earlier in this session, pass them along.

## 3. Delegate
Launch the `red-team` subagent with: the scope, the test command, where tests live and how they're
named, and any hotspots. Ask it to return its report in the format it defines.

## 4. Report
- Present the findings ranked by severity, with the failing test that proves each.
- Run the full test suite once and confirm that only the new red-team tests fail.
- Don't fix anything. Ask which findings to fix, then fix them one at a time (test turns green,
  nothing else breaks).
- The red-team tests stay as regression tests unless I say otherwise.

## Hotspots (attack these first)
Input parsing and validation; API and route boundaries; numeric boundaries and comparisons;
async code (races, cancellation, retries, stale state); error and empty paths; anything touching
files, auth, money or user data; caching; date and time handling; assumptions about data shape.
