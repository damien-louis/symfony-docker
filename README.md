# symfony-docker

An up to date clean Symfony based on docker (PHP, Caddy, Postgres) with QA and tests tools 

- [Symfony 6.3.8](https://github.com/symfony/symfony/releases/tag/v6.3.8)
- [PHP 8.2](https://hub.docker.com/r/dmnlouis/php)
- [Caddy 2.7](https://hub.docker.com/r/dmnlouis/caddy)
- [Postgres 16](https://hub.docker.com/_/postgres)

```
1. git clone git@github.com:damien-louis/symfony-docker.git my-project
2. cd my-project
3. make install
```
**It's enough \o/**
Now you can visit https://app.local (or personal domain if you change `SERVER_NAME` in `.env`/`.env.local`)

### X-Debug :
#### To use PHP with X-Debug enabled:
1. `make stop`
2. In `.env.local`, replace `PHP_IMAGE=` value by `php-xdebug`
3. `make start`

Or use `make restart-with-xdebug` if `sed` is installed on your machine.

#### To return to PHP without X-Debug: 
Follow same steps with putting back `php` value to `PHP_IMAGE=`

Or use `make restart-without-xdebug` if `sed` is installed on your machine.

### QA tools: 

- PHP_CodeSniffer [3.7.2](https://github.com/squizlabs/PHP_CodeSniffer/releases/tag/3.7.2)
- PHP-CS-Fixer [3.38.2](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/tag/v3.38.2)
- PHPStan [1.10.43](https://github.com/phpstan/phpstan/releases/tag/1.10.43)
- PHP Insights [2.10.0](https://github.com/nunomaduro/phpinsights/releases/tag/v2.10.0)
- Twigcs [6.2.0](https://github.com/friendsoftwig/twigcs/releases/tag/6.2.0)
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
