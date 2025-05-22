#!/bin/sh

# Replace environment variables in the env-config.js file
envsubst < /usr/share/nginx/html/env-config.js.template > /usr/share/nginx/html/env-config.js

# Copy and process the Nginx configuration template
envsubst '${NGINX_HOST} ${NGINX_PORT}' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/nginx.conf

# Ensure PID directory exists and has correct permissions
mkdir -p /run
chmod -R 755 /run

# Start Nginx with the processed configuration
exec nginx -g "daemon off;"