FROM php:7.1-fpm
MAINTAINER Alexandre Geffray <geffra.a@gmail.com>

RUN apt-get update && apt-get install -y \
  cron \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  libxslt1-dev \
  mysql-client \
  zip \
  git \
  dos2unix

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
  bcmath \
  gd \
  intl \
  mbstring \
  mcrypt \
  opcache \
  pdo_mysql \
  soap \
  xsl \
  zip

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

ENV PHP_MEMORY_LIMIT 4G
ENV PHP_PORT 9000
ENV PHP_PM dynamic
ENV PHP_PM_MAX_CHILDREN 10
ENV PHP_PM_START_SERVERS 4
ENV PHP_PM_MIN_SPARE_SERVERS 2
ENV PHP_PM_MAX_SPARE_SERVERS 6
ENV APP_MAGE_MODE default

COPY ./conf/www.conf /usr/local/etc/php-fpm.d/
COPY ./conf/php.ini /usr/local/etc/php/
COPY ./conf/php-fpm.conf /usr/local/etc/

COPY ./bin/magento /usr/local/bin/magento
RUN chmod  +x /usr/local/bin/magento
RUN dos2unix /usr/local/bin/magento

COPY ./bin/mage-setup /usr/local/bin/mage-setup
RUN chmod  +x /usr/local/bin/mage-setup
RUN dos2unix /usr/local/bin/mage-setup

COPY ./bin/mage-setup-raw /usr/local/bin/mage-setup-raw
RUN chmod  +x /usr/local/bin/mage-setup-raw
RUN dos2unix /usr/local/bin/mage-setup-raw

COPY ./bin/setup-config /usr/local/bin/setup-config
RUN chmod  +x /usr/local/bin/setup-config
RUN dos2unix /usr/local/bin/setup-config

COPY ./bin/start /usr/local/bin/start
RUN chmod +x /usr/local/bin/start
RUN dos2unix /usr/local/bin/start

WORKDIR /var/www/html

CMD ["/usr/local/bin/start"]
