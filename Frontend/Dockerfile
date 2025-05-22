# Stage 1: Build the Vue.js application
FROM node:18-alpine as builder

# Set working directory
WORKDIR /app

# Build arguments
ARG VITE_API_URL
ENV VITE_API_URL=${VITE_API_URL}

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the application with Nginx
FROM nginx:alpine

# Install envsubst
RUN apk add --no-cache bash gettext

# Create necessary directories with correct permissions
RUN mkdir -p /etc/nginx/templates \
    /var/cache/nginx \
    /run \
    /var/log/nginx \
    && chown -R nginx:nginx /var/cache/nginx /run /var/log/nginx \
    && chmod -R 755 /var/cache/nginx /run /var/log/nginx \
    && chown -R nginx:nginx /etc/nginx/templates

# Copy built files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html/
RUN chown -R nginx:nginx /usr/share/nginx/html && chmod -R 755 /usr/share/nginx/html

# Copy and set permissions for Nginx configuration
COPY nginx.conf.template /etc/nginx/templates/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh && \
    chown -R nginx:nginx /etc/nginx && \
    chmod -R 755 /etc/nginx && \
    chown nginx:nginx /docker-entrypoint.sh

# Create environment config template
RUN echo "window._env_ = {\n\
  VITE_API_URL: '${VITE_API_URL}'\n\
}" > /usr/share/nginx/html/env-config.js.template && \
    chown nginx:nginx /usr/share/nginx/html/env-config.js.template

# Environment variables
ENV VITE_API_URL=${VITE_API_URL}
ENV NGINX_HOST=frontend.local
ENV NGINX_PORT=80

# Add metadata
LABEL maintainer="Your Name <your.email@example.com>"
LABEL description="Frontend application for URL shortener service"
LABEL version="1.0"

# Switch to non-root user
USER nginx

# Expose port
EXPOSE 80

# Start Nginx
CMD ["/docker-entrypoint.sh"] 