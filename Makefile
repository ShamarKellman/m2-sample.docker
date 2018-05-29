include .env

.PHONY: start
start: ## Start docker containers
	docker-compose up -d

.PHONY: stop
stop: ## Stop docker containers
	docker-compose stop

.PHONY: status
status: ## Get docker containers status
	docker-compose ps

.PHONY: console
console: ## Login to docker shell
	${DOCKER_EXEC_TTY} -u ${WEB_USER} ${CONTAINER_SUFFIX}_apache-php_1 /bin/bash -c 'cd /var/www/html; /bin/bash'

.PHONY: console-root
console-root: ## Login to docker shell as root
	${DOCKER_EXEC_TTY} ${CONTAINER_SUFFIX}_apache_1 /bin/bash;

.PHONY: clean
clean: stop ## Flushes database; removes everything from web root
	rm -rf db/*
	rm -rf html

.PHONY: purge
purge: clean ## Tear down everything
	docker-compose rm -f

.PHONY: dbdump
dbdump:
	(${DOCKER_EXEC} ${CONTAINER_SUFFIX}_db_1 mysqldump -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}) | sed -E 's/DEFINER=`[^`]+`@`[^`]+`/DEFINER=CURRENT_USER/g' | gzip -9 -c > dump.sql.gz

.PHONY: pull-db
pull-db: #Pull database from remote location
	wget -O dump.sql.gz ${PRIVATE_BASE_REMOTE}dump.sql.gz

.PHONY: drop-db
drop-db:
	${DOCKER_EXEC} ${CONTAINER_SUFFIX}_db_1 /bin/bash -c 'echo "DROP DATABASE ${MYSQL_DATABASE}; CREATE DATABASE ${MYSQL_DATABASE} COLLATE utf8_unicode_ci" | mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}'

.PHONY: dbimport
dbimport:
	zcat dump.sql.gz | sed -E 's/DEFINER=`[^`]+`@`[^`]+`/DEFINER=CURRENT_USER/g' | ${DOCKER_EXEC_INTERACTIVE} ${CONTAINER_SUFFIX}_db_1 mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}

.PHONY: install
install:
	${DOCKER_EXEC_TTY} -u ${WEB_USER} ${CONTAINER_SUFFIX}_apache-php_1 /bin/bash -c 'cd /var/www/html;composer install;php bin/magento setup:upgrade'