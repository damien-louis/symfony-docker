# symfony-docker

An up to date clean Symfony based on docker (PHP, Caddy, Postgres) with QA and tests tools 

- Symfony 6.3.6
- PHP 8.2
- Caddy 2.7
- Postgres 15

```
1. git clone git@github.com:damien-louis/symfony-docker.git my-project
2. cd my-project
3. make install
```
**It's enough \o/**
Now you can visit https://app.local (or personal domain if you change `SERVER_NAME` in `.env`/`.env.local`

/!\ Don't forget to attach to your own repository : 
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
