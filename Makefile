help:
	@echo Opciones:
	@echo -------------------
	@echo start / stop / restart
	@echo workspace
	@echo stats
	@echo build / clean
	@echo -------------------

_start-command:
	@docker-compose up -d --remove-orphans

start: _start-command _urls

stop:
	@docker-compose stop

restart: stop start

workspace:
	@docker-compose exec moodle /bin/bash

stats:
	@docker stats

build:
	@docker-compose pull && docker-compose build --pull

clean:
	@docker-compose down -v --remove-orphans

_urls:
	${info }
	@echo -------------------
	@echo [Moodle] https://moodle.test
	@echo -------------------
