# Build stage: clonar Moodle con el contenedor oficial de git
FROM alpine/git:latest AS builder

ARG MOODLE_BRANCH=MOODLE_502_STABLE

RUN git clone --branch "${MOODLE_BRANCH}" --depth 1 https://github.com/moodle/moodle.git /moodle

# Stage final: imagen oficial de Moodle con el código copiado
FROM moodlehq/moodle-php-apache:8.4

# Moodle está detrás de Traefik, que termina TLS y reenvía a Apache por HTTP.
# Traefik envía X-Forwarded-Proto=https, pero PHP/Apache no convierten eso
# automáticamente en $_SERVER['HTTPS']='on'. Sin esto, el instalador de Moodle
# genera URLs http://... y el navegador bloquea CSS/JS por mixed content.
RUN printf '%s\n' \
    'SetEnvIf X-Forwarded-Proto "^https$" HTTPS=on' \
    'SetEnvIf X-Forwarded-Ssl "^on$" HTTPS=on' \
    > /etc/apache2/conf-available/traefik-https-proxy.conf \
    && a2enconf traefik-https-proxy

COPY --from=builder /moodle /var/www/html
