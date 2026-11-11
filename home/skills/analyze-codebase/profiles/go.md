# Go profile

- Manifest: go.mod (module path, go version, toolchain), go.sum. Workspaces: go.work.
- Version check: `go version`. Pins: the `go` and `toolchain` lines in go.mod, .tool-versions, mise.toml.
- Layout: cmd/<app>/main.go for binaries, internal/ for private packages, pkg/ if used.
- Tests: `go test ./...`; single test `go test ./path/to/pkg -run TestName`. Add `-race` for concurrent code.
- Lint: golangci-lint config if present; always `gofmt` / `go vet`.

- Coverage: `go test -cover ./...` per package, or `go test -coverprofile=cover.out ./... && go tool cover -func=cover.out | tail -1`
  for the total. Don't leave cover.out in the repo.
## Gotchas
- Errors are values: wrap with %w and check every one; match the repo's error style.
- Watch goroutine leaks and data races in concurrent code; pass context.Context through call chains.
- Don't add dependencies when the standard library does the job.
