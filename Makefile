include .env .env.local

.DEFAULT_GOAL := help

DOCKER 		= docker
DOCKER_COMPOSE 	= docker compose
APP		= $(DOCKER_COMPOSE) exec -it php
CONSOLE 	= $(APP) bin/console
SSL_DIR		= docker/caddy/certs

.PHONY: install
install: ## Project Installation
install: build start vendor reset-db

.PHONY: build
build:
	$(DOCKER_COMPOSE) up --build -d

.PHONY: start
start: ## Start the project
	$(DOCKER_COMPOSE) up --remove-orphans --wait

.PHONY: stop
stop: ## Stop the project
	$(DOCKER_COMPOSE) stop

.PHONY: restart
restart:  ## Restart the project
restart: stop start

.PHONY: reinstall
reinstall:  ## Reinstall the project
reinstall: stop install

.PHONY: php
php: ## Open shell in PHP container
	$(APP) sh

.PHONY: vendor
vendor: ## Execute 'composer install'
	$(APP) composer install

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
qa: lint-yaml lint-twig twigcs lint-container phpcs php-cs-fixer phpstan phpinsights

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
	$(CONSOLE) cache:clear --env=prod
	$(CONSOLE) lint:container --env=prod

.PHONY: phpcs
phpcs: ## PHP_CodeSniffer (https://github.com/squizlabs/PHP_CodeSniffer)
	$(APP) vendor/bin/phpcs -p -n --colors --standard=.phpcs.xml src

.PHONY: phpstan
phpstan: ## Execute phpstan
	$(APP) vendor/bin/phpstan --memory-limit=-1 analyse src

.PHONY: phpinsights
phpinsights: ## PHP Insights (https://phpinsights.com)
	$(APP) vendor/bin/phpinsights analyse --no-interaction

.PHONY: phpinsights-fix
phpinsights-fix: ## PHP Insights (https://phpinsights.com)
	$(APP) vendor/bin/phpinsights analyse --no-interaction --fix

.PHONY: php-cs-fixer
php-cs-fixer: ## Execute php-cs-fixer in dry-run mode
	$(APP) vendor/bin/php-cs-fixer fix --using-cache=no --verbose --diff --dry-run

.PHONY: php-cs-fixer-apply
php-cs-fixer-apply: ## Execute php-cs-fixer and apply changes
	$(APP) vendor/bin/php-cs-fixer fix --using-cache=no --verbose

.PHONY: twigcs
twigcs: ## Twigcs (https://github.com/friendsoftwig/twigcs)
	$(APP) vendor/bin/twigcs templates --severity error --display blocking


##
## —— ✨ Tests ——
.PHONY: tests
tests: ## Execute tests
	$(APP) vendor/bin/simple-phpunit  --colors=always --testdox
	$(APP) vendor/bin/behat


##
## —— ✨ Others ——
.PHONY: help
help: ## List of commands
	@grep -E '(^[a-z0-9A-Z_-]+:.*?##.*$$)|(^##)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
