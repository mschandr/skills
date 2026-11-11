# Go

- Accept interfaces, return structs; define interfaces where they're consumed, keep them small.
- Handle every error; wrap with context using %w; don't panic for expected failures.
- Pass context.Context as the first parameter through request-scoped call chains; respect cancellation.
- Every goroutine has a clear owner and exit path; no leaks; use errgroup or WaitGroup.
- Protect shared state (mutex or channels); run tests with -race for concurrent code.
- Avoid package-level mutable state and init() side effects.
- Package layout by responsibility (cmd/, internal/); avoid util or common grab-bag packages.
- Prefer the standard library before adding dependencies.
- Table-driven tests; httptest for handlers.
