# Node.js

- Don't block the event loop: no sync file/crypto/compression calls or heavy CPU work on request paths;
  offload to workers or queues.
- Every promise is awaited or deliberately handled; no unhandled rejections; async errors reach the
  error handler (Express needs explicit forwarding before v5).
- Validate request input at the boundary with a schema (zod, valibot, joi) rather than ad hoc checks
  scattered through handlers.
- Keep route handlers thin: parse, call a service or lib function, map the result to a response.
- Config via environment, read and validated once at startup, not `process.env` sprinkled everywhere.
- Respect the module system in use (ESM vs CommonJS); avoid mixing.
- Stream large payloads instead of buffering them in memory.
- Use timeouts and retries with backoff for outbound calls; never retry non-idempotent requests blindly.
- Dependencies: avoid heavy libraries for trivial tasks; keep the lockfile committed.
