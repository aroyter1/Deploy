# Build stage
FROM node:18-alpine as builder

# Set working directory
WORKDIR /app

# Install dependencies for building
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build TypeScript code
RUN npm run build

# Production stage
FROM node:18-alpine

# Install PM2 globally
RUN npm install -g pm2

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production && \
    npm cache clean --force

# Copy built files from builder stage
COPY --from=builder /app/dist ./dist

# Создаём PM2-конфиг до смены пользователя!
COPY ecosystem.config.json ./

# Создать папку logs и выдать права пользователю node
RUN mkdir -p /app/logs && chown -R node:node /app/logs

# Switch to non-root user
USER node

# Expose the application port
EXPOSE 3000

# Start the application with PM2
CMD ["pm2-runtime", "start", "ecosystem.config.json", "--env", "production"]

# Add metadata
LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Backend API for URL shortener service"
LABEL version="1.0" 