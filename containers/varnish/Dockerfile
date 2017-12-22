FROM debian:jessie

RUN apt-get update && apt-get install -y curl dos2unix && curl -s https://packagecloud.io/install/repositories/varnishcache/varnish41/script.deb.sh | bash && apt-get update && apt-get install -y varnish vim && apt-get clean

COPY ./bin/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh
RUN dos2unix /usr/local/bin/start.sh

COPY ./conf/default.vcl /etc/varnish/default.vcl
RUN dos2unix /etc/varnish/default.vcl

COPY ./conf/varnish.secret /etc/varnish/secret

ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV CACHE_SIZE      256M
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600 -T 0.0.0.0:6082 -S /etc/varnish/secret

EXPOSE 80 6082

CMD /usr/local/bin/start.sh
