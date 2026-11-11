---
name: red-team
description: Adversarially attack code to find real defects, proving each one with a failing test. Modes - --quick (default; files changed in the last 10 commits plus uncommitted work, up to about 5 findings), --diff (uncommitted changes only, pre-commit check) and --deep (whole codebase or a path, fanned out by area, about 20 findings). Use when asked to red-team, attack, stress or try to break code.
argument-hint: "[--quick | --diff | --deep] [--commits <n>] [path]"
---

# Red team

Arguments: $ARGUMENTS

You coordinate; `red-team` subagents attack. Keep each attack in a fresh context so it isn't anchored on
how the code was built or explained. Every finding, in every mode, must be proven by a failing test.

## 0. Parse the arguments
Mode (pick one; default --quick):
 - `--quick`: files changed in the last N commits (default 10) plus uncommitted and untracked changes.
 - `--diff`: only uncommitted and untracked changes. Quick pre-commit check.
 - `--deep`: the whole codebase, or the given path.
Options:
 - `--commits <n>`: widen or narrow the --quick window. Only valid with --quick.
 - `path`: limit any mode to this file or directory (e.g. `--quick src/lib` = recent changes inside src/lib).
Conflicts (e.g. --quick with --deep, or --commits without --quick): say which and stop.
Unknown flags: say so and ignore them.
Print the effective settings first, e.g. `mode=quick commits=10 path=. files=14`.

## 1. Build the target list
 - --quick: `git log -n <n> --name-only --format= | sort -u`, plus `git diff --name-only` (staged and
   unstaged) and untracked files from `git status --porcelain`. Keep files that still exist.
 - --diff: `git diff --name-only` (staged and unstaged) plus untracked files.
 - --deep: `git ls-files` within the path.
 - In every mode, drop lockfiles, generated and vendored code, binaries, snapshots and docs. Tests stay in
   the list only as context, never as targets.
 - If the list is empty (e.g. no recent changes in the path), say so and stop.

## 2. Gather context for the attackers (briefly)
 - Read the project CLAUDE.md if it exists: commands, conventions, gotchas, test location and naming.
   If not, find the test command and test location yourself.
 - --deep: if a codebase map (docs/CODEBASE.md or CODEBASE.md) exists, use its key files and unfinished-work
   section. If analyze-codebase listed hotspots earlier in this session, pass them along.

## 3. Attack
--quick and --diff: launch one `red-team` subagent with the target list, the test command and test
conventions. Ask for at most 5 confirmed findings for --quick, 3 for --diff, highest impact first.
--deep:
 1. Rank areas by risk: git churn over the last 12 months (`git log --since=12.months --name-only --format=`)
    combined with size or complexity, plus the hotspot categories below.
 2. Split the codebase into up to 5 attack areas (e.g. API boundaries, input parsing, async and concurrency,
    data and persistence, auth and security), each with its own file list.
 3. Launch one `red-team` subagent per area in parallel, each asking for at most 5 confirmed findings.
 4. Merge: remove duplicates (same root cause), rank by severity, keep about 20.
   
This mode is token-heavy. Before launching, state the number of areas and files, and ask me to confirm.

## 4. Report
 - Effective settings and the target list size.
 - Findings ranked by severity, each with the failing test that proves it.
 - Run the full test suite once and confirm that only the new red-team tests fail.
 - Suspected issues that couldn't be proven, briefly, separately.
   --deep: also the areas examined that held up.
 - Don't fix anything. Ask which findings to fix, then fix them one at a time (test turns green,
   nothing else breaks). The red-team tests stay as regression tests unless I say otherwise.

## Hotspots (attack these first, in every mode)
Input parsing and validation; API and route boundaries; numeric boundaries and comparisons;
async code (races, cancellation, retries, stale state); error and empty paths; anything touching
files, auth, money or user data; caching; date and time handling; assumptions about data shape.
