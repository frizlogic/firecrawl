# Stage 1: Build
FROM node:18-slim AS builder

RUN npm install -g pnpm

WORKDIR /app

# Copy the firecrawl subdirectory
COPY firecrawl/package.json firecrawl/pnpm-lock.yaml ./
RUN pnpm install

COPY firecrawl .

RUN pnpm build

# Stage 2: Production image
FROM node:18-slim

RUN npm install -g pnpm

WORKDIR /app

COPY --from=builder /app ./

ENV PORT=8080
EXPOSE 8080

CMD ["pnpm", "start"]
