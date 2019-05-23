FROM subfuzion/envtpl:latest as envtpl

FROM haproxy:1.9.8-alpine

# Default values for keepalived
ENV VRID 40
ENV PRIORITY 100

# Default supervisord admin password
ENV SUPERVISOR_ADMIN_PASS admin

# Install envtpl
COPY --from=envtpl /bin/envtpl /usr/bin/envtpl

ARG INOTIFY_VERSION=3.20.1-r1
ARG SUPERVISOR_VERSION=3.3.4-r1
ARG KEEPALIVED_VERSION=2.0.11-r0
RUN apk add --no-cache --update \
        inotify-tools=$INOTIFY_VERSION \
        supervisor=$SUPERVISOR_VERSION \
        keepalived=$KEEPALIVED_VERSION

CMD ["/usr/local/bin/docker-entrypoint"]

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY haproxy_reload.sh /usr/local/bin/haproxy_reload
COPY etc/supervisord.conf /etc/supervisord.conf
COPY etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf

COPY etc/haproxy /etc/haproxy
