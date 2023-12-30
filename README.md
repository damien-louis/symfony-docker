# Symfony Docker

[![Build Status](https://github.com/damien-louis/symfony-docker/workflows/ci/badge.svg)](https://github.com/damien-louis/symfony-docker/actions?query=workflow%3A%22ci%22)

An up to date clean Symfony based on docker (PHP, Caddy, Postgres) with QA and tests tools.  
Behat component isn't available for Symfony 7 for the moment. Please use Symfony 6.4 if you need Behat.

- [Symfony 7.0.2](https://github.com/symfony/symfony/releases/tag/v7.0.2)
- [PHP 8.3](https://hub.docker.com/r/dmnlouis/php)
- [Caddy 2.7](https://hub.docker.com/r/dmnlouis/caddy)
- [Postgres 16](https://hub.docker.com/_/postgres)

```
1. git clone git@github.com:damien-louis/symfony-docker.git my-project
2. cd my-project
3. make install
```
**It's enough \o/**
Now you can visit https://app.local (or personal domain if you change `SERVER_NAME` in `.env`/`.env.local`)

### PHP versions:
You can change `PHP_VERSION` in `.env.local` to switch to another version.  
Versions available on https://hub.docker.com/r/dmnlouis/php:
- 8.2
- 8.3

### X-Debug:
#### To use PHP with X-Debug enabled:
1. `make stop`
2. In `.env.local`, replace `PHP_IMAGE=` value by `php-xdebug`
3. `make start`

Or use `make restart-with-xdebug` if `sed` is installed on your machine.

#### To return to PHP without X-Debug: 
Follow same steps with putting back `php` value to `PHP_IMAGE=`

Or use `make restart-without-xdebug` if `sed` is installed on your machine.

### QA tools: 

- PHP_CodeSniffer [3.8.0](https://github.com/squizlabs/PHP_CodeSniffer/releases/tag/3.8.0)
- PHP-CS-Fixer [3.45.0](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/tag/v3.45.0)
- PHPStan [1.10.50](https://github.com/phpstan/phpstan/releases/tag/1.10.50)
- PHP Insights [2.11.0](https://github.com/nunomaduro/phpinsights/releases/tag/v2.11.0)
- YML Linter
- Twig Linter 
- Service Container Linter

### /!\ Don't forget to attach to your own repository: 
```
1. rm -rf .git
2. git init
3. git remote add origin <your repo>
4. git checkout -b first-commit
5. git add .
6. git commit -m "First commit"
7. git push origin first-commit
```

Execute `make` to list commands (`make qa`, `make tests`...)

You can remove `.github` folder if you don't use Github
