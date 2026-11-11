# Roadmap

## Next
- Test every skill against a repo with real history (Agent CommonRoom first, then Space Wars 3002).
  Keep a log of where each skill was wrong; fix from evidence.
- analyze-codebase: verify the three common invocations (plain, --deep, --update --skip-tests).

## Planned
- Explicit defaults table in analyze-codebase, then `.cnf` overrides in MySQL style:
  `~/.claude/analyze-codebase.cnf` and per-repo `.claude/analyze-codebase.cnf`, `[analyze-codebase]` section,
  same keys as the flags. Precedence: flags > repo cnf > user cnf > built-in. Print effective settings and sources.
- Restructure guideline files into the spec format: rule IDs (e.g. LAR-DATA-01), objective vs preference,
  how to detect, severity, version gates ("applies to"), exceptions, sources.
- Layered guidelines: general > language (versioned) > framework (versioned, optional) > house
  (`.claude/guidelines.md`, inferred for custom frameworks). Security and correctness rules can't be overridden.
- Complexity thresholds in general.md (cyclomatic > 10 warn, > 20 high; nesting > 4; function > ~50 lines;
  params > 5), measured with lizard / phpmd / phploc / phpcpd.

## Later
- Legacy PHP 5 guidelines: register_globals and $_REQUEST (top priority), mysql_* and concatenated SQL,
  global/extract, eval/create_function, variable includes, @ suppression, md5/sha1 passwords,
  htmlspecialchars without charset, magic quotes, PEAR-style names and __autoload, singletons and registries,
  mixed PHP/HTML/SQL, arrays as untyped DTOs, configuration sprawl.
- House preference: avoid magic methods (__get/__set) for property access (opt-in preference rule).

## Decided against (for now)
- Global test hook. Runner detection is fragile, it's slow on large suites, and a blocking hook fights
  test-first work at the red step. /verify is the explicit gate; any hook should be non-blocking.
