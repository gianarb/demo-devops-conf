FROM php:7.0-zts-alpine

ADD $PWD /code
RUN apk add --update
RUN apk add openssl-dev autoconf make g++
RUN pecl install mongodb
RUN echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini
WORKDIR /code
RUN curl -Ss https://getcomposer.org/installer | php
RUN php composer.phar install
