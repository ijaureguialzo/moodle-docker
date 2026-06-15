# Build stage: clonar Moodle con el contenedor oficial de git
FROM alpine/git:latest AS moodle_builder

ARG MOODLE_BRANCH=MOODLE_502_STABLE

RUN git clone --branch "${MOODLE_BRANCH}" --depth 1 https://github.com/moodle/moodle.git /moodle

# Build stage: descargar el plugin MCP de Moodle
FROM alpine/git:latest AS mcp_plugin_builder

ARG MCP_PLUGIN_REPO=https://github.com/ijaureguialzo/moodle-webservice_mcp.git
ARG MCP_PLUGIN_BRANCH=main

RUN git clone --branch "${MCP_PLUGIN_BRANCH}" --depth 1 "${MCP_PLUGIN_REPO}" /mcp

# Stage final: imagen oficial de Moodle con el código copiado
FROM moodlehq/moodle-php-apache:8.4

ARG MOODLE_DATABASE_HOST=mariadb
ARG MOODLE_DATABASE_PORT_NUMBER=3306
ARG MOODLE_DATABASE_NAME=moodle
ARG MOODLE_DATABASE_USER=moodle
ARG MOODLE_DATABASE_PASSWORD=12345Abcde
ARG MOODLE_WWWROOT=https://moodle.test

COPY --from=moodle_builder /moodle /var/www/html

# Moodle 5.1+ usa /public como webroot. Los plugins de tipo webservice van en public/webservice/<nombre>.
# El plugin webservice_mcp debe quedar como public/webservice/mcp, no como public/webservice/webservice_mcp.
COPY --from=mcp_plugin_builder /mcp /var/www/html/public/webservice/mcp

RUN chown -R root:root /var/www/html/public/webservice/mcp \
    && find /var/www/html/public/webservice/mcp -type d -exec chmod 755 {} \; \
    && find /var/www/html/public/webservice/mcp -type f -exec chmod 644 {} \;

# Moodle está detrás de Traefik, que termina TLS y reenvía a Apache por HTTP.
RUN printf '%s\n' \
    'SetEnvIf X-Forwarded-Proto "^https$" HTTPS=on' \
    'SetEnvIf X-Forwarded-Ssl "^on$" HTTPS=on' \
    > /etc/apache2/conf-available/traefik-https-proxy.conf \
    && a2enconf traefik-https-proxy

# Generar config.php: copiar la plantilla y sustituir placeholders por los ARGs de docker-compose.yml
COPY config.php /var/www/html/config.php
RUN sed -i \
    -e "s|%MOODLE_DATABASE_HOST%|${MOODLE_DATABASE_HOST}|g" \
    -e "s|%MOODLE_DATABASE_PORT_NUMBER%|${MOODLE_DATABASE_PORT_NUMBER}|g" \
    -e "s|%MOODLE_DATABASE_NAME%|${MOODLE_DATABASE_NAME}|g" \
    -e "s|%MOODLE_DATABASE_USER%|${MOODLE_DATABASE_USER}|g" \
    -e "s|%MOODLE_DATABASE_PASSWORD%|${MOODLE_DATABASE_PASSWORD}|g" \
    -e "s|%MOODLE_WWWROOT%|${MOODLE_WWWROOT}|g" \
    /var/www/html/config.php
