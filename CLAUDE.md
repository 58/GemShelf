# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GemShelf is a personal cloud file uploader built with Rails 8.1, SQLite, Active Storage, and Tailwind CSS v4. The UI is in Japanese.

## Development Environment

Development runs entirely in Docker:

```bash
docker compose up                                    # start dev server + Tailwind watcher
docker compose run --rm web bin/rails db:migrate     # run migrations
docker compose run --rm web bin/rails console        # Rails console
docker compose run --rm web bin/rails test           # run all unit/integration tests
docker compose run --rm web bin/rails test:system    # run system tests
docker compose run --rm web bin/rails test test/models/upload_test.rb        # single file
docker compose run --rm web bin/rails test test/models/upload_test.rb:10     # single test by line
```

## Linting and Security

```bash
docker compose run --rm web bin/rubocop              # lint (rubocop-rails-omakase style)
docker compose run --rm web bin/brakeman --no-pager  # security static analysis
docker compose run --rm web bin/bundler-audit        # gem vulnerability scan
docker compose run --rm web bin/importmap audit       # JS dependency audit
```

## Architecture

- **Authentication**: Rails 8 generated authentication pattern in `app/controllers/concerns/authentication.rb`. Cookie-based sessions using `has_secure_password`. `Current` (CurrentAttributes) exposes `Current.session` and `Current.user`. All controllers require authentication by default; use `allow_unauthenticated_access` to opt out.
- **File storage**: `Upload` model uses Active Storage (`has_one_attached :file`). Files stored on local disk (`storage/`). Uploads are scoped to `Current.user`.
- **Database**: SQLite for all environments. Production uses separate SQLite databases for cache, queue, and cable (Solid Cache/Queue/Cable).
- **Frontend**: Tailwind CSS v4 via `tailwindcss-rails` gem with a separate `css` container watching for changes. Hotwire (Turbo + Stimulus) with import maps (no Node.js/bundler).
- **Deployment**: Fly.io (`fly.toml`), with persistent volume mounted at `/rails/storage`.

## Testing

- Minitest with fixtures (Rails default).
- `test/test_helpers/session_test_helper.rb` provides `sign_in_as(user)` and `sign_out` for controller/integration tests. Automatically included in integration tests.
- CI runs: rubocop, brakeman, bundler-audit, importmap audit, unit tests, and system tests (see `.github/workflows/ci.yml`).
