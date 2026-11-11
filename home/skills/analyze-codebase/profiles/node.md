# Node / JavaScript / TypeScript profile

- Manifest: package.json. Check `engines`, `scripts`, `type` (module vs commonjs), dependencies and devDependencies.
- Package manager, decided by lockfile: package-lock.json -> npm, pnpm-lock.yaml -> pnpm, yarn.lock -> yarn,
  bun.lock(b) -> bun. Use that manager's commands, never mix.
- Version check: `node --version` and the manager's `--version`. Pins: `engines.node`, .nvmrc, .node-version,
  .tool-versions, mise.toml.
- Tests: the `test` script. Single file: `npx jest <path>` (Jest) or `npx vitest run <path>` (Vitest).
  Testing Library present -> component tests query by role or text, not implementation details.
- Language: tsconfig.json -> TypeScript; jsconfig.json -> JavaScript with path aliases (note the aliases).
- Frameworks to detect from dependencies: next, react, vue, svelte/sveltekit, express, fastify, nestjs, vite.
- Lint and format: eslint config, prettier config. Note the commands if scripts exist.

- Coverage: Jest `npx jest --coverage --coverageReporters=text-summary`; Vitest `npx vitest run --coverage`
  (needs @vitest/coverage-v8; ask before installing). Node's own runner: `node --test --experimental-test-coverage`.
## Gotchas
- Next.js App Router: `app/` directory, server components by default, `'use client'` needed for hooks
  and browser APIs. In Next 15+, `params` and `searchParams` are Promises: `const { id } = await params;`.
  Route handlers live in `app/**/route.js|ts`.
- React 19: no need to import React for JSX; check for any use of removed legacy APIs.
- ESM vs CommonJS: respect `type` in package.json and the existing import style.
- Don't run `npm audit fix --force` during feature work; it can pull breaking upgrades.
