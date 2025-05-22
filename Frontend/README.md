# Vue 3 + TypeScript + Vite

This template should help get you started developing with Vue 3 and TypeScript in Vite. The template uses Vue 3 `<script setup>` SFCs, check out the [script setup docs](https://v3.vuejs.org/api/sfc-script-setup.html#sfc-script-setup) to learn more.

Learn more about the recommended Project Setup and IDE Support in the [Vue Docs TypeScript Guide](https://vuejs.org/guide/typescript/overview.html#project-setup).

# Frontend Application

Vue3-based frontend application for URL shortener service.

## Docker Build Instructions

### Prerequisites
- Docker installed on your system
- Access to the internet for pulling base images

### Building the Docker Image

Basic build with default settings:
```bash
docker build -t frontend-app .
```

Build with custom API URL:
```bash
docker build --build-arg VUE_APP_API_URL=https://api.local -t frontend-app .
```

### Running the Container

Basic run command:
```bash
docker run -d -p 80:80 --name frontend frontend-app
```

With environment variables:
```bash
docker run -d \
  -p 80:80 \
  --name frontend \
  frontend-app
```

### Docker Compose Example

```yaml
version: '3.8'

services:
  frontend:
    build:
      context: .
      args:
        VUE_APP_API_URL: https://api.local
    ports:
      - "80:80"
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

### Environment Variables

- `VUE_APP_API_URL`: Backend API URL (default: https://api.local)

### Security Features

- Uses non-root Nginx user
- Implements proper caching headers
- Enables Gzip compression
- Includes health check endpoint

### Production Deployment

For production deployment on SRV1 (192.168.100.10):

1. Add the following entry to your hosts file:
```
192.168.100.10 frontend.local
```

2. Use the provided Docker Compose file
3. Ensure proper network configuration
4. Configure SSL/TLS if needed (recommended for production)
