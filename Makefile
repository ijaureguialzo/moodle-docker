#!make

help: _header
	${info }
	@echo Opciones:
	@echo ----------------------
	@echo build / certs
	@echo start / stop / restart
	@echo ----------------------
	@echo workspace
	@echo cron
	@echo clean
	@echo ----------------------

_urls: _header
	${info }
	@echo -------------------------------------
	@echo [Moodle] https://moodle.test
	@echo [Traefik] https://traefik.moodle.test
	@echo -------------------------------------

_header:
	@echo ------
	@echo Moodle
	@echo ------

build:
	@docker-compose pull && docker-compose build --pull

certs:
	@traefik/crear_certs.sh moodle.test

_start-command:
	@docker-compose up -d --remove-orphans

start: _start-command _urls

stop:
	@docker-compose down

restart: stop start

workspace:
	@docker-compose exec moodle /bin/bash

cron:
	@docker compose exec -u www-data moodle /usr/local/bin/php /var/www/html/admin/cli/cron.php

clean:
	@docker-compose down -v --remove-orphans
