ARG PHP_VERSION=8.1.2
ARG COMPOSER_VERSION=2.4.2
ARG APCU_VERSION=5.1.22
ARG XDEBUG_VERSION=3.1.5
ARG AMQP_VERSION=1.11.0

# --------------------------------------------
# Composer
# --------------------------------------------
FROM composer:${COMPOSER_VERSION} as composer

# --------------------------------------------
# base stage
# --------------------------------------------
FROM php:${PHP_VERSION}-fpm AS base
LABEL maintainer="Roger Guasch <rogerguasch.code@gmail.com>"

RUN apt-get update && apt-get install -y ca-certificates git libzip-dev libpng-dev librabbitmq-dev libicu-dev sudo libpq-dev \
    && pecl install apcu-${APCU_VERSION} \
    && pecl install xdebug-${XDEBUG_VERSION} \
    && pecl install amqp-${AMQP_VERSION} \
    && pecl install redis


# --------------------------------------------
# development stage
# --------------------------------------------
FROM base AS dev

WORKDIR /app

RUN docker-php-ext-configure intl
RUN docker-php-ext-install opcache pdo pdo_mysql zip bcmath gd intl pdo pdo_pgsql pgsql
RUN docker-php-ext-enable redis opcache apcu xdebug amqp intl

RUN echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
RUN echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | sudo tee /etc/apt/sources.list.d/symfony-cli.list
RUN apt-get update && apt-get install symfony-cli


COPY --from=composer /usr/bin/composer  /usr/bin/composer
COPY config /usr/local/etc/php/conf.d/

ADD bin/disable_xdebug.sh /usr/local/bin/disable_xdebug.sh
ADD bin/enable_xdebug.sh /usr/local/bin/enable_xdebug.sh
RUN chmod u+x /usr/local/bin/disable_xdebug /usr/local/bin/enable_xdebug

# --------------------------------------------
# clear
# --------------------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*