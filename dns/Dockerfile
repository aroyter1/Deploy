FROM alpine:latest

# Install dnsmasq
RUN apk add --no-cache dnsmasq

# Create configuration directory
RUN mkdir -p /etc/dnsmasq.d

# Copy configuration files
COPY dnsmasq.conf /etc/dnsmasq.conf
COPY generate-hosts.sh /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/

# Make scripts executable and generate initial hosts file
RUN chmod +x /usr/local/bin/generate-hosts.sh /usr/local/bin/entrypoint.sh && \
    /usr/local/bin/generate-hosts.sh

# Expose DNS ports
EXPOSE 53/tcp 53/udp

# Start dnsmasq
CMD ["/usr/local/bin/entrypoint.sh"] 