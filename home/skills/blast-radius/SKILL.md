---
name: blast-radius
description: Before changing code, map everything a change could affect - direct and transitive dependents, user-facing surfaces, data contracts, history-based coupling, and which tests cover it - and rate the risk. Use when asked about the impact, repercussions or blast radius of changing a file, function or line, or before a risky refactor. Arguments - a target (file, file:line, file:symbol, or --diff) and optionally the intended change.
argument-hint: "<file | file:line | file:symbol | --diff> [intended change]"
---

# Blast radius

Arguments: $ARGUMENTS

Goal: before anything is edited, show what could break, how far it spreads, and how to change it safely.
Read-only.

## 1. Resolve the target
- file:line: identify the enclosing function, method, class or exported value.
- file:symbol: find its definition.
- file only: list its exports or public surface; treat each as a target.
- --diff: every symbol touched by the current uncommitted change.
- Note the kind of change if given, because the radius differs:
  - internal refactor (same inputs, same outputs): radius is mostly tests;
  - behaviour change (same signature, different results): every caller is affected;
  - signature or shape change (params, return value, data format): every caller and every consumer
    of the data breaks unless updated.
  If no change is described, assume a behaviour change and say so.

## 2. Find dependents
1. Direct references: use an LSP "find references" capability if available; otherwise search for the symbol
   name and its import paths (account for re-exports, aliases such as `@/`, and barrel files).
2. Transitive dependents: walk the reverse import graph (JS/TS `npx madge --depends <file>` or repeated
   searches; PHP via `use` statements; Go `go list`), up to 3 levels, noting depth.
3. Indirect and dynamic links that static search misses: string-based lookups, dependency injection
   containers, event names, route names, config keys, reflection, templates, serialized data.
4. History coupling: files that changed in the same commits as the target over the last 12 months
   (`git log --format=%H -- <file>` then the files in those commits). Frequent co-change with no import
   link is a hidden dependency.

## 3. Map surfaces
- User-facing: which pages, components, API endpoints, CLI commands or jobs ultimately use it.
- Data contracts: API response shapes, database schema, files or messages other systems consume.
  Changes here can break consumers outside this repo, so flag them prominently.
- Configuration and environment that the target reads.

## 4. Tests
- Tests that exercise the target and its dependents. For Jest, `npx jest --listTests --findRelatedTests <file>`;
  otherwise map test files by imports.
- Dependents with no test coverage: list them as the blind spots.

## 5. Danger rating (always for --diff; for other targets, rate the intended change)
Read the danger scale: `.claude/shared/danger-levels.md` in the project if it exists, otherwise
`~/.claude/shared/danger-levels.md` and apply it: classify every hunk, then rate the whole change
as its most dangerous part, applying the escalation rules and the Critical safeguards.

## 6. Report
- **Danger:** overall level from section 5, with a per-hunk table for --diff (hunk, level, reason,
  reversible yes/no).
- **Map:** a Mermaid graph with the target in the middle, dependents by depth, user-facing surfaces and data
  contracts at the edge, and untested nodes marked.
- **Tables:** direct dependents; transitive (with depth); surfaces and contracts; history-coupled files;
  tests to run; untested blind spots.
- **Safe-change plan:** tests to add before touching it; whether to keep the old behaviour behind a flag or
  deprecate gradually; the order to update callers; what to verify after.
- **Confidence:** say what static analysis can't see (dynamic calls, external consumers) and how sure the map is.

## Rules
- Read-only. Never edit while mapping.
- Prefer real tools and searches over guessing; state the method behind each list.
