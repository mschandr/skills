# PHP profile

- Manifest: composer.json (require, require-dev, autoload PSR-4 namespaces, scripts). Lockfile: composer.lock.
- Version check: `php --version`, `composer --version`. Pins: `require.php` in composer.json, .tool-versions,
  mise.toml.
- Tests: Pest (tests/Pest.php) or PHPUnit (phpunit.xml). Run with `./vendor/bin/pest` or
  `./vendor/bin/phpunit`; single test with `--filter <name>`. Laravel: `php artisan test`.
- Frameworks to detect: laravel/framework (artisan, app/, routes/), symfony, slim.
- Style and analysis: pint, php-cs-fixer, phpstan or larastan config.

- Coverage: `./vendor/bin/phpunit --coverage-text` or `./vendor/bin/pest --coverage`. Needs pcov or Xdebug;
  if neither is installed, estimate instead and say so.
## Gotchas
- Laravel: business logic in services/actions, not controllers, if that's the existing pattern; follow it.
  Migrations are append-only once run. Config is cached in production, so read env through config(), not env().
- Respect strict_types and existing PSR-12 style.
- Check the PHP version before using newer syntax (enums need 8.1, readonly classes 8.2, property hooks 8.4).
