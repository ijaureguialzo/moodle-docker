# Build stage: clonar Moodle con el contenedor oficial de git
FROM alpine/git:latest AS moodle_builder

ARG MOODLE_BRANCH=MOODLE_502_STABLE

RUN git clone --branch "${MOODLE_BRANCH}" --depth 1 https://github.com/moodle/moodle.git /moodle

# Build stage: descargar el plugin MCP de Moodle
FROM alpine/git:latest AS mcp_plugin_builder

ARG MCP_PLUGIN_REPO=https://github.com/onbirdev/moodle-webservice_mcp.git
ARG MCP_PLUGIN_BRANCH=main

RUN git clone --branch "${MCP_PLUGIN_BRANCH}" --depth 1 "${MCP_PLUGIN_REPO}" /mcp

# Stage final: imagen oficial de Moodle con el código copiado
FROM moodlehq/moodle-php-apache:8.4

COPY --from=moodle_builder /moodle /var/www/html

# Moodle 5.1+ usa /public como webroot. Los plugins de tipo webservice van en public/webservice/<nombre>.
# El plugin webservice_mcp debe quedar como public/webservice/mcp, no como public/webservice/webservice_mcp.
COPY --from=mcp_plugin_builder /mcp /var/www/html/public/webservice/mcp

# Moodle está detrás de Traefik, que termina TLS y reenvía a Apache por HTTP.
RUN printf '%s\n' \
    'SetEnvIf X-Forwarded-Proto "^https$" HTTPS=on' \
    'SetEnvIf X-Forwarded-Ssl "^on$" HTTPS=on' \
    > /etc/apache2/conf-available/traefik-https-proxy.conf \
    && a2enconf traefik-https-proxy \
    && chown -R root:root /var/www/html/public/webservice/mcp \
    && find /var/www/html/public/webservice/mcp -type d -exec chmod 755 {} \; \
    && find /var/www/html/public/webservice/mcp -type f -exec chmod 644 {} \; \
