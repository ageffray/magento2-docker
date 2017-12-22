FROM nginx:1.13
MAINTAINER Alexandre Geffray <geffra.a@gmail.com>

ENV PHP_HOST phpfpm
ENV PHP_PORT 9000
ENV APP_MAGE_MODE default

RUN apt-get update && apt-get install -y dos2unix openssl

COPY ./conf/nginx.conf /etc/nginx/
COPY ./conf/default.conf /etc/nginx/conf.d/
COPY ./conf/basic.conf /etc/nginx/conf.d/basic.conf
COPY ./conf/ssl.conf /etc/nginx/conf.d/ssl.conf

COPY ./bin/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
RUN dos2unix /usr/local/bin/start.sh

WORKDIR /var/www/html

CMD ["/usr/local/bin/start.sh"]
