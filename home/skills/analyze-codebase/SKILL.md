---
name: analyze-codebase
description: Map an unfamiliar repository and draft a project CLAUDE.md; with --deep, also write CODEBASE.md, a per-file map of the source. Use when starting work in a new or unfamiliar repo, or when asked to understand, map, document or onboard onto a codebase. Optional arguments - ecosystem or framework and version (e.g. "node 26", "laravel 11"), and flags --deep, --update, --map-only, --scope <dir>, --skip-tests, --skip-coverage, --output-file-path <path>, --trust.
argument-hint: "[ecosystem|framework] [version] [--deep] [--update] [--map-only] [--scope <dir>] [--skip-tests] [--skip-coverage] [--output-file-path <path>] [--trust]"
---

# Analyze codebase

Arguments: $ARGUMENTS

## 0. Parse the arguments
Positional (both optional):
- First: an ecosystem (node, python, php, go) or a framework (next, react, laravel, django, fastapi, ...).
  A framework implies its language: load the language profile, and note the framework for its gotchas.
- Second: the expected version of that ecosystem or framework.
Flags:
- `--deep`: also build the codebase map (section 8).
- `--update`: refresh, don't start over. Read the commit hash recorded in the existing map (or CLAUDE.md
  notes) and only re-examine what changed since, plus new and deleted files. Implies --deep if a map exists.
- `--map-only`: build or refresh only the codebase map; skip the CLAUDE.md draft. Implies --deep.
- `--scope <dir>`: analyze only this directory (monorepo package, or one large area). Outputs describe
  that scope, and the map goes next to it unless --output-file-path says otherwise.
- `--skip-tests`: skip the test baseline (section 6). Implies --skip-coverage. Say so in the summary.
- `--skip-coverage`: run the tests but don't measure coverage (coverage runs can be slow).
- `--output-file-path <path>`: write the codebase map here instead of the default location.
- `--trust`: write outputs without stopping for approval. Still show what was written. If a file
  already existed, report a short diff of what changed. Never use --trust behaviour unless the flag is given.
Unknown flags: say so and ignore them; don't guess what they meant.

Goal: in a few minutes, understand this repo well enough to work in it safely, and leave behind a short,
true project CLAUDE.md. Sample representative files; don't read everything.

## 1. Pick the profile
- If an ecosystem was given, read `profiles/<ecosystem>.md` from this skill's folder.
- Otherwise detect it from manifest files in the repo root:
  package.json -> node, pyproject.toml / requirements.txt -> python, composer.json -> php, go.mod -> go.
- Several manifests means a polyglot repo: load each relevant profile and say so.
- No matching profile: carry on with the generic steps and say which details you had to infer.

## 2. Check the runtime
- If a version was given, compare it with the installed version (command in the profile) and with any pins
  in the repo (see the profile, plus .tool-versions and mise.toml).
- Report mismatches clearly. Don't switch versions yourself; suggest the command, e.g. `mise use node@26`.

## 3. Map the repo
- List tracked files with `git ls-files` (skips dependencies and build output). If it isn't a git repo,
  use `find` and exclude dependency and build folders.
- Group by top-level directory with one line of purpose each.
- Read the manifest: language and framework versions, scripts or commands, key dependencies.

## 4. Trace the main flow
- Find the entry points, where data comes from, how it reaches the UI or API, and how state is managed.
- Describe it as one short chain, e.g. "data/listings.json -> src/lib -> API route -> client component".

## 5. Learn the conventions from real code
- Read 2 or 3 representative files: one of each main kind (e.g. a component, an endpoint, a test).
- Note naming, file layout, styling approach, error handling and test style. These are what new code must match.

## 6. Baseline (skipped with --skip-tests)
- If dependencies aren't installed, ask before installing.
- Run the test command from the profile. Record pass/fail counts so later failures are clearly ours.
- Note anything already broken, flaky or slow.

## 6a. Metrics
Gather these once; they feed the summary, CLAUDE.md and the codebase map. State the method behind each number.

### Purpose
- Work out what the product is for and who uses it, from the README, docs, entry points and domain names
  in the code. Two or three plain sentences: what it does, for whom, and its current stage
  (prototype, production, legacy). If sources disagree, say so.

### Size: source lines
- Same file set as the codebase map: `git ls-files` minus lockfiles, build output, generated code,
  vendored code, binary assets and snapshots (section 8 lists them).
- Prefer a counter that separates code from blanks and comments: `scc`, `tokei` or `cloc`, whichever is
  installed (don't install one without asking). Fallback: physical line counts with `wc -l` over the
  filtered list, labelled as physical lines.
- Report: total code lines; split into source, tests and other (config, scripts); top languages by lines.

### Test coverage
- Skipped with --skip-coverage or --skip-tests.
- Use the profile's coverage command, ideally in the same run as the baseline. Report overall line or
  statement coverage, and the least-covered important packages or directories (up to 5).
- If coverage needs something not installed (e.g. a PHP coverage driver) or would be slow, don't force it:
  report an estimate instead, by mapping test files to the source they import, clearly labelled
  "estimated from test-to-source mapping, not measured".

### Unfinished work
Search the included source and tests (not vendored or generated files) for:
- Markers: TODO, FIXME, HACK, XXX, TBD, "not implemented", "unimplemented", "for now", "temporary".
- Stubs: e.g. `throw new Error("Not implemented")`, `panic("not implemented")`, `raise NotImplementedError`,
  `pass  # TODO`, empty function bodies with a placeholder comment.
- Skipped or incomplete tests: `it.skip`, `test.todo`, `xit`, `t.Skip`, `@pytest.mark.skip`,
  `markTestIncomplete`, `markTestSkipped`.
Report: total, counts by kind, the files with the most, and the 5 that look most significant
(e.g. in core logic, security or data paths), with file and line. Ignore matches inside string fixtures
and test data.

## 7. Output
1. Draft a project CLAUDE.md with these sections, only including what's true and useful:
   a two- or three-sentence purpose statement at the very top, then Commands (dev, test, single test,
   coverage, build, lint), Stack (with versions), Layout, Conventions, Gotchas, Don'ts.
   Don't put volatile numbers (line counts, coverage, TODO counts) in CLAUDE.md; they go in the map.
   Keep it under about 40 lines. Show the draft and wait for approval before writing it (unless --trust).
   Skipped entirely with --map-only.
   If a CLAUDE.md already exists, propose a diff instead of replacing it.
2. In chat, a summary of about 12 lines, starting with the purpose commentary, then one metrics line
   (source lines, coverage, unfinished-work count), then the main flow, test baseline, risks,
   up to 3 questions I'd ask the team, and up to 3 hotspots worth red-teaming
   (areas most likely to hide defects, for /red-team).

## 8. Deep mode (only with --deep): CODEBASE.md
A compact map of the source, as reference material. It is NOT CLAUDE.md, which is loaded every session.
Location: `--output-file-path` if given; otherwise `docs/CODEBASE.md` if a docs/ folder exists, else `CODEBASE.md` at the root.
Whatever the location, make the CLAUDE.md draft point to the actual path.

### Size budget (hard limits)
- Target 300 to 400 lines in total. Never more than about 600.
- If the repo can't fit, split: one short index file plus one map file per large top-level area
  (e.g. `docs/codebase/cmd-server.md`), each under about 300 lines, linked from the index.
- Spend detail where it pays: key files get 2 or 3 lines; everything else gets one line or is grouped.
- Be token-economical while building it: sample and skim; don't read whole large files to write one line.

### Which files
Start from `git ls-files`, then exclude:
- Lockfiles (package-lock.json, pnpm-lock.yaml, yarn.lock, composer.lock, go.sum, poetry.lock, uv.lock).
- Build output and generated code: dist/, build/, out/, .next/, coverage/, *.min.*, *.map, generated
  clients and reference docs, protobuf output, anything with a "generated, do not edit" header.
- Vendored dependencies and vendored skills: vendor/, node_modules/, third_party/.
- Binary assets: images, fonts, audio, video, PDFs, archives.
- Test snapshots (__snapshots__/, *.snap).

### Group instead of listing
- Tests: one line per test directory or per feature group, saying what's covered and the test style,
  not one line per test file.
- Docs: one line per docs folder (user, technical, archive), plus any doc that defines architecture or rules.
- Data and fixtures: schema, record count and size, not contents.
- Config: one line per tool, grouped.
- Migrations: a timeline, not file by file.
- Many small similar files (one script per feature, per-route handlers): list them in a compact table
  or a comma-separated line under their directory, with detail only for the important ones.

### What to write
- Key files (entry points, core logic, shared modules, heavily imported, hotspots): main exports,
  what they depend on, one gotcha.
- Other source files: path and one line of purpose, or grouped as above.
- At the very top: the purpose commentary (a short paragraph), then a metrics block: source lines
  (split as in 6a, with the method), test coverage (measured or estimated), unfinished-work count by kind,
  and the commit hash and date it was built from (`git rev-parse --short HEAD`).
- Near the end: an "Unfinished work" section listing the significant TODOs and stubs with file and line
  (all of them if there are under about 30, otherwise the significant ones plus counts per directory).

### Scaling and updates
- Large repo (roughly 150+ included files): split by top-level directory and summarize each part with a
  parallel subagent, then merge, enforcing the size budget during the merge.
- If the map already exists, read its commit hash and only re-summarize files changed since then
  (`git diff --name-only <hash>..HEAD`), plus new and deleted files. Update the hash.
- Show a short preview and the final line count, and ask before writing (unless --trust).

## Rules
- Read-only apart from writing CLAUDE.md and the codebase map after approval.
- Don't refactor, fix or "improve" anything during analysis. Note it instead.
