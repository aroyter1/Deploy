#!/bin/sh

# Create hosts file
cat > /etc/dnsmasq.d/custom-hosts << EOF
172.20.0.3 frontend.local
172.20.0.4 api.frontend.local
172.20.0.10 backend1.local
172.20.0.11 backend2.local
EOF 