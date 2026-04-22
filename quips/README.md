# Quips

A minimal HTTP API for storing and retrieving short text snippets ("quips") with optional tags.
This is the **spine project** for [ClaudeCodeLabs](https://github.com/CCLabs) — every lab builds on top of it.

## Quick start

```bash
npm ci
npm test    # 5 Vitest tests, no network required
npm start   # listens on :3000 (set PORT env to override)
```

## API

| Method   | Path          | Body / Query        | Response              |
|----------|---------------|---------------------|-----------------------|
| GET      | /health       | —                   | `{ok: true}`          |
| POST     | /quips        | `{text, tags?[]}`   | `201 {id, text, tags}`|
| GET      | /quips        | `?tag=<string>`     | `200 [{id,text,tags}]`|
| GET      | /quips/:id    | —                   | `200 {id,text,tags}` or `404` |
| DELETE   | /quips/:id    | —                   | `204` or `404`        |

## Environment variables

| Variable       | Default      | Description                        |
|----------------|--------------|------------------------------------|
| `PORT`         | `3000`       | HTTP port                          |
| `QUIPS_DB_PATH`| `:memory:`   | SQLite file path (persists data)   |
