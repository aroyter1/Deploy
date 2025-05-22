# Backend API Service

Node.js/Express.js backend service for URL shortener application.

## Docker Build Instructions

### Prerequisites
- Docker installed on your system
- Access to MongoDB instance
- Access to the internet for pulling base images

### Building the Docker Image

Basic build with default settings:
```bash
docker build -t backend-api .
```

### Environment Variables

The application supports the following environment variables:

- `PORT`: Application port (default: 3000)
- `MONGODB_URI`: MongoDB connection string (default: mongodb://db.local:27017/mydb)
- `NODE_ENV`: Node environment (default: production)

### Running the Container

Basic run command:
```bash
docker run -d \
  -p 3000:3000 \
  --name backend \
  backend-api
```

With custom environment variables:
```bash
docker run -d \
  -p 3000:3000 \
  -e PORT=3000 \
  -e MONGODB_URI=mongodb://db.local:27017/mydb \
  --name backend \
  backend-api
```

### Docker Compose Example

For deployment on SRV1 (192.168.100.10) and SRV2 (192.168.100.11):

```yaml
version: '3.8'

services:
  backend:
    build:
      context: .
    environment:
      - PORT=3000
      - MONGODB_URI=mongodb://db.local:27017/mydb
      - NODE_ENV=production
    ports:
      - "3000:3000"
    networks:
      - app-network
    deploy:
      replicas: 2
      placement:
        constraints:
          - "node.role==worker"
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

networks:
  app-network:
    driver: bridge
```

### Production Deployment

For production deployment on SRV1 (192.168.100.10) and SRV2 (192.168.100.11):

1. Ensure MongoDB is running on SRV3 (db.local)
2. Add the following entries to your hosts file on all servers:
```
192.168.100.12 db.local
```

3. Deploy using Docker Swarm:
```bash
docker stack deploy -c docker-compose.yml backend
```

### Features

- Uses PM2 for process management
- Non-root user for security
- Optimized Docker image (multi-stage build, cleaned npm cache)
- Health check endpoint
- Cluster mode support
- Environment variable configuration

### Monitoring

The application can be monitored using PM2:
```bash
docker exec -it backend pm2 monit
```

### Logs

View application logs:
```bash
docker logs backend
```

Or using PM2:
```bash
docker exec -it backend pm2 logs
``` 