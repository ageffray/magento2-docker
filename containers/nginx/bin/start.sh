#!/bin/bash
[ ! -z "${PHP_HOST}" ]                 && sed -i "s/PHP_HOST/${PHP_HOST}/" /etc/nginx/conf.d/default.conf
[ ! -z "${PHP_PORT}" ]                 && sed -i "s/PHP_PORT/${PHP_PORT}/" /etc/nginx/conf.d/default.conf
[ ! -z "${APP_MAGE_MODE}" ]            && sed -i "s/APP_MAGE_MODE/${APP_MAGE_MODE}/" /etc/nginx/conf.d/default.conf

if [ -z ${DH_SIZE+x} ]
then
  >&2 echo ">> no \$DH_SIZE specified using default"
  DH_SIZE="2048"
fi

mkdir /etc/nginx/external

DH="/etc/nginx/external/dh.pem"

if [ ! -e "$DH" ]
then
  echo ">> seems like the first start of nginx"
  echo ">> doing some preparations..."
  echo ""

  echo ">> generating $DH with size: $DH_SIZE"
  openssl dhparam -out "$DH" $DH_SIZE
fi

if [ ! -e "/etc/nginx/external/cert.pem" ] || [ ! -e "/etc/nginx/external/key.pem" ]
then
  echo ">> generating self signed cert"
  openssl req -x509 -newkey rsa:4086 \
  -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=localhost" \
  -keyout "/etc/nginx/external/key.pem" \
  -out "/etc/nginx/external/cert.pem" \
  -days 3650 -nodes -sha256
fi

ls -la /etc/nginx/external

echo ">> copy /etc/nginx/external/*.conf files to /etc/nginx/conf.d/"
cp /etc/nginx/external/*.conf /etc/nginx/conf.d/ 2> /dev/null > /dev/null

ls -la /etc/nginx/conf.d

# wait varnish before execute nginx
while ! ping -c 1 varnish; do
	sleep 1
done

# exec CMD
echo ">> exec docker CMD"
echo "$@"
exec "$@"

/usr/sbin/nginx -g "daemon off;"
