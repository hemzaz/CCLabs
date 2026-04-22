# TODO: pin base image by digest in a later lab, e.g.:
#   FROM node:20-alpine@sha256:<digest>
# For now we use a floating tag for simplicity.

# ── Stage 1: install dependencies ──────────────────────────────────────────
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# ── Stage 2: production image ───────────────────────────────────────────────
FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY src ./src
COPY package.json ./
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "src/server.js"]
