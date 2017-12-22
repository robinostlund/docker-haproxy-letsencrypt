#!/bin/bash
. /usr/local/bin/sources.sh
. /usr/local/bin/tools.sh

# renew letsencrypt certificate
/opt/letsencrypt/letsencrypt/letsencrypt-auto renew --force-renewal --preferred-challenges http --http-01-port=8888 --config-dir /data/etc/letsencrypt --cert-name haproxy
LETSENCRYPT_EXIT_CODE=$?

if [ $LETSENCRYPT_EXIT_CODE -eq 0 ]; then
  # add new certificate for haproxy
  if [ -e /data/etc/letsencrypt/live/haproxy/fullchain.pem ]; then
    if [ -e /data/etc/letsencrypt/live/haproxy/privkey.pem ]; then
      cat /data/etc/letsencrypt/live/haproxy/{fullchain.pem,privkey.pem} > /data/etc/haproxy/ssl/haproxy.pem
    fi
  fi
fi
# reload haproxy
kill -HUP `pgrep -o -x haproxy`
