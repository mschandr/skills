# Python (general, plus Django and FastAPI notes)

- Type hints on public functions; run a type checker if the project has one configured.
- Use the project's environment tool (uv, poetry, pip + venv); pin dependencies.
- No mutable default arguments; no bare except; don't swallow exceptions.
- Context managers for files, connections and locks.
- Django: avoid N+1 with select_related (FK, one-to-one) and prefetch_related (many);
  keep views thin (logic in services or model methods, per house style); use forms or serializers
  for validation; settings and secrets from the environment; never edit applied migrations;
  database indexes for filtered and ordered fields.
- FastAPI: Pydantic models at the boundary; dependencies for auth and DB sessions;
  no blocking I/O inside async endpoints (use sync def or a threadpool).
- Logging via the logging module, not print.
