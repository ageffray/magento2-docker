#!/bin/bash

set -e

# wait web container before launch varnish

while ! ping -c 1 web; do
	sleep 1
done

exec bash -c \
  "exec varnishd -F \
  -f $VCL_CONFIG \
  -s malloc,$CACHE_SIZE \
  $VARNISHD_PARAMS"
