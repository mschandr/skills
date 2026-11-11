---
name: architecture-review
description: Evidence-based architecture review. Measures dependency structure, complexity, change hotspots and change coupling from git history, and test coverage, then judges the system against layered, ecosystem-specific guidelines (general, language, framework, house). Use when asked for an architecture review, design review, code health or tech-debt assessment. Optional argument - a path to focus on.
argument-hint: "[path]"
---

# Architecture review

Arguments: $ARGUMENTS

Goal: judge how the system is put together, with measurements, not impressions. Every finding is anchored
to evidence in the code or its history, and to a named guideline, principle or concrete cost.
(Line-level correctness is /red-team's job; impact of a specific change is /blast-radius.)

## 1. Context
- Read CLAUDE.md and CODEBASE.md if they exist. If not, map the repo briefly (manifest, `git ls-files`,
  entry points).
- Identify language, framework and their versions. Note if the framework is custom or unrecognized.

## 2. Load guidelines (layered)
Read from this skill's `guidelines/` folder:
1. `general.md`: always.
2. The language file(s), applying only rules whose version range matches.
3. The framework file(s), if a recognized framework is present. If the framework is custom or has no
   guideline file, skip this layer; don't invent framework rules.
4. House rules: the repo's `.claude/guidelines.md` if present. If absent and the codebase has clear
   patterns of its own (especially with a custom framework), infer them and include a draft
   `.claude/guidelines.md` in the report, marked "inferred, needs team confirmation".
Precedence: house > framework > language > general, except security and correctness rules,
which nothing overrides. Rules marked as preference are reported only if the house file opts in.
If the stack is newer than a guideline assumes, check official docs or upgrade guides and cite them.

## 3. Measure (use real tools; install nothing without asking)
Prefer tools already in the project; otherwise use npx/pipx-style one-off runs if I approve, or fall back
to grep and reading. Say which method produced each number.
1. Dependency graph: JS/TS `npx madge --json` (and `--circular`); PHP deptrac or composer autoload plus
   grep of `use` statements; Python import graph (pydeps or grep); Go `go list -deps -json ./...`.
   Find cycles, layer violations, and the most-depended-on modules.
2. Complexity: `lizard` (language-agnostic: JS, TS, PHP, Python, Go, more) for cyclomatic complexity,
   function length and parameter count. Thresholds from general.md.
3. Hotspots: churn from git history, e.g.
   `git log --since=12.months --format= --name-only | sort | uniq -c | sort -rn`,
   combined with complexity. Complex and frequently changed files are where cost and bugs concentrate.
   If history is too short to be meaningful, say so.
4. Change coupling: pairs of files that change in the same commits often but have no import link
   (hidden dependencies).
5. Tests: which modules and hotspots have tests (coverage report if one can be produced cheaply,
   otherwise map test files to source files).
For a large repo, fan out parallel subagents per area for steps 1 to 5, then merge.

## 4. Judge
Walk the guidelines against the measured hotspots first, then sample the rest of each layer:
boundaries and responsibilities; data flow and state ownership; coupling; framework practice;
failure and scale (what breaks first at 10x data, traffic or team size); consistency with CLAUDE.md.

## 5. Report
- Verdict, 3 to 5 lines: overall health, biggest risk, single best improvement.
- Hotspot table: file, complexity, changes in the period, tests yes/no, risk rank.
- Architecture diagram (Mermaid) of the current structure, marking cycles and layer violations.
- Findings, most important first, about 10 at most:
  - **ID and title** (`AR-1: ...`), **Guideline** (rule ID or doc link), **Evidence** (file, line,
    metric), **Impact** now and at scale, **Recommendation** with a one-line trade-off, **Effort** S/M/L.
  - Label each finding "problem now" or "problem if it grows".
- What's done well, worth keeping.
- Roadmap: findings in a suggested order, grouping quick wins first.
- Offer to turn chosen findings into /plan items, and to run /blast-radius before any risky change.

## Rules
- Read-only, apart from the optional draft house guidelines file (show it, write only if approved).
- No taste-based findings. No finding without evidence.
