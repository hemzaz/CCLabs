import { describe, it, expect, beforeEach } from 'vitest';
import { buildServer } from '../src/server.js';
import { resetDb } from '../src/db.js';

let app;

beforeEach(async () => {
  resetDb();
  app = buildServer();
  await app.ready();
});

describe('GET /health', () => {
  it('returns ok', async () => {
    const res = await app.inject({ method: 'GET', url: '/health' });
    expect(res.statusCode).toBe(200);
    expect(res.json()).toEqual({ ok: true });
  });
});

describe('POST /quips', () => {
  it('creates a quip and returns 201', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/quips',
      payload: { text: 'Hello world', tags: ['fun'] },
    });
    expect(res.statusCode).toBe(201);
    const body = res.json();
    expect(body.id).toBeDefined();
    expect(body.text).toBe('Hello world');
    expect(body.tags).toEqual(['fun']);
  });
});

describe('GET /quips/:id', () => {
  it('returns 200 for existing quip and 404 for missing', async () => {
    const created = await app.inject({
      method: 'POST',
      url: '/quips',
      payload: { text: 'Find me' },
    });
    const { id } = created.json();

    const found = await app.inject({ method: 'GET', url: `/quips/${id}` });
    expect(found.statusCode).toBe(200);
    expect(found.json().text).toBe('Find me');

    const missing = await app.inject({ method: 'GET', url: '/quips/9999' });
    expect(missing.statusCode).toBe(404);
  });
});

describe('GET /quips', () => {
  it('lists all quips and filters by tag', async () => {
    await app.inject({ method: 'POST', url: '/quips', payload: { text: 'A', tags: ['x'] } });
    await app.inject({ method: 'POST', url: '/quips', payload: { text: 'B', tags: ['y'] } });

    const all = await app.inject({ method: 'GET', url: '/quips' });
    expect(all.json().length).toBe(2);

    const filtered = await app.inject({ method: 'GET', url: '/quips?tag=x' });
    const items = filtered.json();
    expect(items.length).toBe(1);
    expect(items[0].text).toBe('A');
  });
});

describe('DELETE /quips/:id', () => {
  it('returns 204 on delete and 404 for missing', async () => {
    const created = await app.inject({
      method: 'POST',
      url: '/quips',
      payload: { text: 'Delete me' },
    });
    const { id } = created.json();

    const del = await app.inject({ method: 'DELETE', url: `/quips/${id}` });
    expect(del.statusCode).toBe(204);

    const missing = await app.inject({ method: 'DELETE', url: '/quips/9999' });
    expect(missing.statusCode).toBe(404);
  });
});
