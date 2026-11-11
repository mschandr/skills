# PHP

- declare(strict_types=1) in new files where the codebase uses it; type every parameter and return.
- Follow PSR-12 style and PSR-4 autoloading; one class per file.
- No logic in templates beyond presentation.
- Parameterized queries only (PDO prepared statements or the ORM); never interpolate input into SQL.
- Escape output by context (HTML, attributes, JS, URLs).
- Use exceptions, not error codes or silent false returns; don't suppress errors with @.
- Prefer composition and small classes; avoid static helper sprawl and global state.
- Use modern language features appropriate to the PHP version (enums 8.1+, readonly 8.1/8.2+,
  match, constructor promotion) rather than ad hoc constants and arrays.
- Composer: commit composer.lock for applications; avoid unmaintained packages.
