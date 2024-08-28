FROM php:8.3.11RC2-fpm-alpine

RUN apk --update --no-cache add openssl curl ca-certificates git

RUN printf "%s%s%s\n" \
    "http://nginx.org/packages/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | tee -a /etc/apk/repositories

RUN curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub && \
    openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout && \
    mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/

RUN apk add nginx

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions exif soap gmp pdo_odbc zip mysqli pdo_pgsql bcmath gd odbc pdo_mysql gettext bz2 pdo_dblib

COPY --from=composer:latest  /usr/bin/composer /usr/bin/composer

RUN addgroup -S container && adduser -S container -G container

USER container
ENV  USER=container
ENV  HOME=/home/container

WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh


CMD ["/bin/ash", "/entrypoint.sh"]
