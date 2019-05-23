#! /bin/sh

set -e           # exit in some command fails
set -u           # exit if it tries to use some var undefined
set -o pipefail  # exit if some command on a pipe fails

# Configure keepalived with environment variables
envtpl -m error -o /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf

# Configure supervisord admin password
envtpl -m error -o /etc/supervisord.conf /etc/supervisord.conf

# Response with hostname for haproxy own check health
# http://127.0.0.1:9990/health
echo -e "HTTP/1.0 200 OK\nCache-Control: no-cache\nConnection: close\nContent-Type: text/plain\n\n$(hostname)" > /var/lib/haproxy.http

# Run haproxy and keepalived
supervisord -c /etc/supervisord.conf
