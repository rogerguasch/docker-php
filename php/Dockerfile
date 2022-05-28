FROM composer:latest as composer

FROM php:8.1-fpm

WORKDIR /app

RUN  apt-get update && apt-get install -y ca-certificates git libzip-dev libpng-dev librabbitmq-dev libicu-dev sudo \
    && pecl install apcu-5.1.21 \
    && pecl install xdebug-3.1.3 \
    && pecl install amqp-1.11.0 \
    && pecl install redis

RUN docker-php-ext-configure intl
RUN docker-php-ext-install opcache pdo pdo_mysql zip bcmath gd intl
RUN docker-php-ext-enable redis opcache apcu xdebug amqp intl

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY php/config /usr/local/etc/php/conf.d/

RUN echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | sudo tee /etc/apt/sources.list.d/symfony-cli.list
RUN apt-get update && apt-get install symfony-cli

## Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
