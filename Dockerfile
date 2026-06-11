# Build stage: clonar Moodle con el contenedor oficial de git
FROM alpine/git:2.47.0 AS builder

ARG MOODLE_BRANCH=MOODLE_502_STABLE

RUN git clone --branch "${MOODLE_BRANCH}" --depth 1 https://github.com/moodle/moodle.git /moodle

# Stage final: imagen oficial de Moodle con el código copiado
FROM moodlehq/moodle-php-apache:8.4

COPY --from=builder /moodle /var/www/html
