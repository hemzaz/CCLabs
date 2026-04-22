import Fastify from 'fastify';
import sensible from '@fastify/sensible';
import { createQuip, getQuip, listQuips, deleteQuip } from './db.js';

export function buildServer() {
  const app = Fastify({ logger: false });
  app.register(sensible);

  app.get('/health', async () => ({ ok: true }));

  app.post('/quips', async (req, reply) => {
    const { text, tags } = req.body ?? {};
    if (!text || typeof text !== 'string') {
      return reply.badRequest('text is required');
    }
    const quip = createQuip({ text, tags });
    return reply.code(201).send(quip);
  });

  app.get('/quips/:id', async (req, reply) => {
    const quip = getQuip(Number(req.params.id));
    if (!quip) return reply.notFound();
    return quip;
  });

  app.get('/quips', async (req) => {
    return listQuips({ tag: req.query.tag });
  });

  app.delete('/quips/:id', async (req, reply) => {
    const deleted = deleteQuip(Number(req.params.id));
    if (!deleted) return reply.notFound();
    return reply.code(204).send();
  });

  return app;
}

async function start() {
  const app = buildServer();
  const port = Number(process.env.PORT ?? 3000);
  await app.listen({ port, host: '0.0.0.0' });
  console.log(`Quips listening on port ${port}`);
}

// Run only when executed directly (not imported)
const isMain = process.argv[1] === new URL(import.meta.url).pathname;
if (isMain) {
  start().catch((err) => {
    console.error(err);
    process.exit(1);
  });
}
