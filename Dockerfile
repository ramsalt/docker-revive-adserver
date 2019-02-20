FROM wodby/php:7.2

ARG REVIVE_VERSION

ENV PHP_REALPATH_CACHE_TTL="3600" \
    PHP_OUTPUT_BUFFERING="16384"

USER root

RUN set -ex; \
    WEBROOT="/var/www/html"; \
    \
    # Create destination dir
    su-exec wodby mkdir -p "${WEBROOT}/revive"; \
    \
    # Revive Adserver software
    revive_adserver_url="https://download.revive-adserver.com/revive-adserver-${REVIVE_VERSION}.tar.gz"; \
    wget -qO- "${revive_adserver_url}" | su-exec wodby tar zx -C "${WEBROOT}/revive" --strip-components=1; \
    \
    # Static content
    mkdir -p "$WEBROOT/revive-static/images"; \
    chown www-data:www-data "${WEBROOT}/revive-static/images"; \
    \
    # Cache file
    chown www-data:www-data "${WEBROOT}/revive/var/cache"; \
    chmod 775 "${WEBROOT}/revive/var/cache"

USER wodby

COPY templates /etc/gotpl/
COPY bin /usr/local/bin
COPY init /docker-entrypoint-init.d/