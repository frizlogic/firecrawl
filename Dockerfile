# Stage 1: Build
FROM node:18-slim AS builder

# Install pnpm globally
RUN npm install -g pnpm

# Set working directory
WORKDIR /app

# Copy package files and install deps
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

# Copy rest of the codebase
COPY . .

# Build the project
RUN pnpm build

# Stage 2: Serve with a minimal image
FROM node:18-slim

# Install pnpm again in runtime image
RUN npm install -g pnpm

WORKDIR /app

# Copy only the necessary files from build stage
COPY --from=builder /app ./

# Cloud Run uses PORT env variable
ENV PORT=8080

# Expose the port
EXPOSE 8080

# Start the app
CMD ["pnpm", "start"]