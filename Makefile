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
	${DOCKER_EXEC_TTY} -u ${WEB_USER} ${DOCKER_WEB} /bin/bash;cd /var/www/html

.PHONY: console-root
console-root: ## Login to docker shell as root
	${DOCKER_EXEC_TTY} ${DOCKER_WEB} /bin/bash;

.PHONY: clean
clean: stop ## Flushes database; removes everything from web root
	rm -rf db/*
	rm -rf html

.PHONY: purge
purge: clean ## Tear down everything
	docker-compose rm -f

.PHONY: dbdump
dbdump: start
	(${DOCKER_EXEC} ${CONTAINER_SUFFIX}_db_1 mysqldump -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}) | sed -E 's/DEFINER=`[^`]+`@`[^`]+`/DEFINER=CURRENT_USER/g' | gzip -9 -c > dump.sql.gz

.PHONY: dbpull
dbpull:
	wget -O db.sql.gz http://echo:echo4u@10.1.2.171/stage-oneills/db_0328_0033.sql.gz

.PHONY: dbimport
dbimport: start
	sleep 10
	pv dump.sql.gz | zcat | sed -E 's/DEFINER=`[^`]+`@`[^`]+`/DEFINER=CURRENT_USER/g' | ${DOCKER_EXEC} ${CONTAINER_SUFFIX}_db_1 mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE}

.PHONY: install
install:html/index.php
	${DOCKER_EXEC} -u inchoo ${DOCKER_WEB} /bin/bash -c 'cd ${WEB_ROOT};composer install;n98-magerun2 script:repo:run n98-local-db-update;php bin/magento setup:upgrade;';

html/index.php: ## Magento installation
	git clone git@github.com:magento/magento2.git html
	cd html;git checkout 2.2
	${DOCKER_EXEC_INTERACTIVE} ${DOCKER_WEB} /bin/bash;cd ${WEB_ROOT};
	php bin/magento setup:install --base-url=${SERVER_NAME} \
    --db-host=db --db-name=inchoo --db-user=inchoo --db-password=inchoo \
    --admin-firstname=Tomas --admin-lastname=Novoselic --admin-email=tomas@inchoo.net \
    --admin-user=admin --admin-password=inchoo --language=en_US \
    --currency=USD --timezone=America/Chicago --use-rewrites=1