# Stage 1: Build
FROM node:18-slim AS builder

# Install pnpm globally
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Copy package files (they are at the root)
COPY package.json pnpm-lock.yaml ./

# Install dependencies
RUN pnpm install

# Copy the rest of the app
COPY . .

# Build the app
RUN pnpm build

# Stage 2: Create production image
FROM node:18-slim

# Install pnpm globally again for runtime
RUN npm install -g pnpm

WORKDIR /app

# Copy the built app
COPY --from=builder /app ./

# Set environment and expose port
ENV PORT=8080
EXPOSE 8080

# Start the app
CMD ["pnpm", "start"]