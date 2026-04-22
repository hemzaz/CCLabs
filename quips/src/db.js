import Database from 'better-sqlite3';

const DB_PATH = process.env.QUIPS_DB_PATH ?? ':memory:';

let db;

function getDb() {
  if (!db) {
    db = new Database(DB_PATH);
    db.exec(`
      CREATE TABLE IF NOT EXISTS quips (
        id   INTEGER PRIMARY KEY,
        text TEXT    NOT NULL,
        tags TEXT    NOT NULL DEFAULT '[]'
      )
    `);
  }
  return db;
}

function rowToQuip(row) {
  return { id: row.id, text: row.text, tags: JSON.parse(row.tags) };
}

export function createQuip({ text, tags = [] }) {
  const stmt = getDb().prepare('INSERT INTO quips (text, tags) VALUES (?, ?)');
  const result = stmt.run(text, JSON.stringify(tags));
  return getQuip(result.lastInsertRowid);
}

export function getQuip(id) {
  const row = getDb().prepare('SELECT * FROM quips WHERE id = ?').get(id);
  return row ? rowToQuip(row) : null;
}

export function listQuips({ tag } = {}) {
  const rows = getDb().prepare('SELECT * FROM quips').all();
  const quips = rows.map(rowToQuip);
  if (!tag) return quips;
  return quips.filter((q) => q.tags.includes(tag));
}

export function deleteQuip(id) {
  const result = getDb().prepare('DELETE FROM quips WHERE id = ?').run(id);
  return result.changes > 0;
}

// Exposed for tests to reset state between runs
export function resetDb() {
  if (db) {
    db.close();
    db = null;
  }
}
