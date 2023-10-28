# symfony-docker

An up to date clean Symfony based on docker (PHP, Caddy, Postgres) with QA and tests tools 

- [Symfony 6.3.6](https://github.com/symfony/symfony/releases/tag/v6.3.6)
- [PHP 8.2](https://hub.docker.com/_/php)
- [Caddy 2.7](https://hub.docker.com/_/caddy)
- [Postgres 16](https://hub.docker.com/_/postgres)

```
1. git clone git@github.com:damien-louis/symfony-docker.git my-project
2. cd my-project
3. make install
```
**It's enough \o/**
Now you can visit https://app.local (or personal domain if you change `SERVER_NAME` in `.env`/`.env.local`)

### QA tools: 

- PHP_CodeSniffer (3.7.2)
- PHP-CS-Fixer : (3.37.0)
- PHPStan : (1.10.39)
- PHP Insights : (2.9.0)
- Twigcs : (6.2.0)
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
