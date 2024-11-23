include .env .env.local

.DEFAULT_GOAL := help

DOCKER 		= docker
DOCKER_COMPOSE 	= docker compose
APP		= $(DOCKER_COMPOSE) exec -it php
CONSOLE 	= $(APP) bin/console

.env.local: .env
	@if [ ! -f .env.local ]; then \
		cp .env .env.local; \
		echo ".env.local is missing, file was copied from .env"; \
	fi

##
## —— ✨ Docker ——
.PHONY: install
install: ## Project Installation
install: .env.local build start vendor reset-db

.PHONY: build
build:
	$(DOCKER_COMPOSE) --env-file .env.local up --build -d

.PHONY: start
start: ## Start the project
	$(DOCKER_COMPOSE) --env-file .env.local up --remove-orphans --wait

.PHONY: stop
stop: ## Stop the project
	$(DOCKER_COMPOSE) --env-file .env.local stop

.PHONY: restart
restart:  ## Restart the project
restart: stop start

.PHONY: reinstall
reinstall:  ## Reinstall the project
reinstall: stop install

##
## —— ✨ PHP / Symfony ——
.PHONY: php
php: ## Open shell in PHP container
	$(APP) sh

.PHONY: vendor
vendor: ## Execute 'composer install'
	$(APP) composer install

.PHONY: vendor-update
vendor-update: ## Execute 'composer update'
	$(APP) composer update -W

.PHONY: cc
cc: ## Execute 'cache:clear'
	$(CONSOLE) cache:clear

##
## —— ✨ Database ——
.PHONY: reset-db
reset-db: ## Reset database
	$(CONSOLE) doctrine:database:drop --if-exists --force
	$(CONSOLE) doctrine:database:create
	$(CONSOLE) doctrine:schema:update --force

.PHONY: dump-db
dump-db: ## Dump database: make dump-db file=dump.sql
	$(DOCKER_COMPOSE) exec --interactive database pg_dump --clean --dbname=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@127.0.0.1:5432/${POSTGRES_DB} > $(file)

.PHONY: restore-db
restore-db: ## Restore database: make restore-db file=dump.sql
	$(DOCKER_COMPOSE) exec -T --interactive database psql --dbname=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@127.0.0.1:5432/${POSTGRES_DB} < $(file)


##
## —— ✨ Code Quality ——
.PHONY: qa
qa: ## Run all code quality checks
qa: lint-yaml lint-twig lint-container phpcs php-cs-fixer phpstan phpinsights

.PHONY: qa-fix
qa-fix: ## Run all code quality fixers
qa-fix: phpinsights-fix php-cs-fixer-apply

.PHONY: lint-yaml
lint-yaml: ## Lints YAML files
	# Need PHP dependencies (run "make composer-install" if needed)
	$(APP) vendor/bin/yaml-lint config --parse-tags

.PHONY: lint-twig
lint-twig:## Lints Twig files
	# Need PHP dependencies (run "make composer-install" if needed)
	$(CONSOLE) lint:twig templates

.PHONY: lint-container
lint-container: ## Lints containers
	# Need PHP dependencies (run "make composer-install" if needed)
	$(CONSOLE) cache:clear
	$(CONSOLE) lint:container

.PHONY: phpcs
phpcs: ## PHP_CodeSniffer (https://github.com/squizlabs/PHP_CodeSniffer)
	$(APP) vendor/bin/phpcs -p -n --colors --standard=./qa/.phpcs.xml src

.PHONY: phpstan
phpstan: ## Execute phpstan
	$(APP) vendor/bin/phpstan --memory-limit=-1 -c"./qa/phpstan.dist.neon" analyse src

.PHONY: phpinsights
phpinsights: ## PHP Insights (https://phpinsights.com)
	$(APP) vendor/bin/phpinsights analyse --config-path="./qa/phpinsights.php" --no-interaction

.PHONY: phpinsights-fix
phpinsights-fix: ## PHP Insights (https://phpinsights.com)
	$(APP) vendor/bin/phpinsights analyse --config-path="./qa/phpinsights.php" --no-interaction --fix

.PHONY: php-cs-fixer
php-cs-fixer: ## Execute php-cs-fixer in dry-run mode
	$(APP) vendor/bin/php-cs-fixer fix --config=./qa/.php-cs-fixer.dist.php --using-cache=no --verbose --diff --dry-run

.PHONY: php-cs-fixer-apply
php-cs-fixer-apply: ## Execute php-cs-fixer and apply changes
	$(APP) vendor/bin/php-cs-fixer fix --config=./qa/.php-cs-fixer.dist.php --using-cache=no --verbose

##
## —— ✨ Tests ——
.PHONY: tests
tests: ## Execute tests
	$(APP) vendor/bin/simple-phpunit --configuration ./tests/phpunit.xml.dist --colors=always --testdox
	$(APP) vendor/bin/behat --config ./tests/behat.yml

##
## —— ✨ Others ——
.PHONY: help
help: ## List of commands
	@grep -E '(^[a-z0-9A-Z_-]+:.*?##.*$$)|(^##)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
