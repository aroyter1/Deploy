#!/bin/bash

# Default values
BACKEND_COUNT=${BACKEND_COUNT:-1}
BACKEND_PORT=${BACKEND_PORT:-3000}

# Generate upstream configuration
cat > /etc/nginx/conf.d/upstream.conf << EOF
upstream backend_servers {
    least_conn; # Load balancing method
EOF

# Add backend servers
for ((i=1; i<=BACKEND_COUNT; i++)); do
    BACKEND_HOST="backend${i}"
    echo "    server ${BACKEND_HOST}:${BACKEND_PORT};" >> /etc/nginx/conf.d/upstream.conf
done

# Close upstream block
echo "}" >> /etc/nginx/conf.d/upstream.conf

# Generate main nginx configuration
cat > /etc/nginx/conf.d/default.conf << EOF
server {
    listen 80;
    server_name localhost;

    root /usr/share/nginx/html;
    index index.html;

    # Frontend static files
    location / {
        try_files \$uri \$uri/ /index.html;
        add_header Cache-Control "no-cache";
    }

    # API proxy
    location /api/ {
        proxy_pass http://backend_servers/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF 