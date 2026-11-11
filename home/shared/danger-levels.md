# Danger levels for code changes

Shared by /blast-radius and /commit. Edit here only.
Classify every hunk or logical change, then rate the whole change as its most dangerous part.
The key question is reversibility: can reverting the code fully undo the effect?

| Level | Meaning | Examples |
|---|---|---|
| None | No runtime or user-visible effect | Comments, docs, whitespace; spelling fixes in static content such as a privacy policy page |
| Trivial | Cosmetic, user-visible, no logic | Button label or pluralization, colour or spacing tweaks |
| Low | Local logic change, covered by tests, easy to revert | A bug fix inside one pure function with tests; a new optional parameter |
| Medium | Behaviour change with wider reach, or weak test coverage | Logic used by several callers; untested paths; config defaults; minor dependency upgrades; performance-sensitive code |
| High | Contracts, security or money, but recoverable | API or response shape changes; auth, permissions, sessions; payments or pricing; reversible schema changes (adding a column or index); caching and invalidation; concurrency; major dependency upgrades; infrastructure or deployment config |
| Critical | Effects that reverting the code cannot undo | Deleting or altering stored data; destructive migrations (drop or rename column or table, type changes that truncate); bulk UPDATE or DELETE; purge, retention or cleanup jobs; changes to backups or restore; encryption, hashing or key changes that make existing data unreadable; anything that could expose personal or secret data (a leak can't be taken back) |

Escalate a level when:
- the changed code has no tests, or is a hotspot;
- "text" is actually an identifier: strings used as i18n keys, test selectors or assertions, route names,
  config or cache keys, or values stored in a database. A label fix that breaks a test or a lookup is not trivial.
- the change crosses a data contract with consumers outside the repo.

For each Critical item, require before proceeding: explicit confirmation from me, a verified backup or
restore path, a dry run or a count of affected rows, and a rollback plan. Never run it as part of this skill.

