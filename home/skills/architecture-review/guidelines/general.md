# General architecture principles (all stacks)

- Separation of concerns: I/O (HTTP, DB, files) at the edges; business rules in plain, testable code.
- Single source of truth for each piece of state; derived data is computed, not stored twice.
- Dependencies point inward: domain logic doesn't import framework, transport or UI code.
- Validate at the boundary: every external input (request, file, env, third-party API) is parsed
  and validated once, where it enters.
- Fail loudly and specifically: no swallowed errors; errors carry context; users never see internals.
- Configuration and secrets come from the environment, never hard-coded or committed.
- Avoid premature abstraction: an interface or layer with one implementation and no test seam is cost.
- Duplication is cheaper than the wrong abstraction, but copied business rules drift: centralize rules.
- Performance basics: no per-item queries or calls in loops; paginate unbounded lists; index lookups;
  cache with an explicit invalidation story.
- Testability: core logic testable without the framework; tests at the right level (unit for logic,
  a few integration tests for wiring).
- Observability: meaningful logs at boundaries, no secrets or personal data in logs.
- Security: least privilege; authorization checked server-side on every protected action; parameterized queries.
