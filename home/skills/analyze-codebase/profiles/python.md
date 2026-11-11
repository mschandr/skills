# Python profile

- Manifest: pyproject.toml (preferred), else setup.cfg / setup.py / requirements*.txt.
- Environment manager, decided by files: uv.lock -> uv, poetry.lock -> poetry, Pipfile.lock -> pipenv,
  otherwise pip with a venv. Check whether a virtualenv is active or present (.venv/).
- Version check: `python --version` (inside the project env). Pins: `requires-python`, .python-version,
  .tool-versions, mise.toml.
- Tests: pytest if present (`pytest`, single file `pytest path/to/test_x.py::test_name`), else unittest.
  Look for conftest.py fixtures.
- Frameworks to detect: django (manage.py, settings), fastapi, flask, celery, sqlalchemy, pydantic.
- Lint, format and types: ruff, black, mypy or pyright config.

- Coverage: `pytest --cov --cov-report=term` (needs pytest-cov) or `coverage run -m pytest && coverage report`.
## Gotchas
- Never install into the system Python; use the project's env tool.
- Django: migrations folder per app; don't edit applied migrations.
- Async frameworks (FastAPI): don't call blocking I/O inside async endpoints.
