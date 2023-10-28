FROM php:8.2-fpm-alpine

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apk add --no-cache postgresql-dev npm && \
docker-php-ext-install pdo pdo_pgsql intl && \
docker-php-ext-configure intl && \
npm install --quiet --global yarn;

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && chmod +x /usr/local/bin/composer
