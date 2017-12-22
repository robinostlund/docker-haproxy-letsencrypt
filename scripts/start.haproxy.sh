#!/bin/bash
. /usr/local/bin/sources.sh
. /usr/local/bin/tools.sh

set -x

# create letsencrypt certificate if not exists
if [ ! -d "/data/etc/letsencrypt" ]; then
  if [ "$LETSENCRYPT_ENABLED" = "yes" ]; then
    generate_letsencrypt_certificate
  fi
fi

# create letsencrypt certificate if forced
if [ -d "/data/etc/letsencrypt" ]; then
  if [ "$LETSENCRYPT_ENABLED" = "yes" ]; then
    if [ "$LETSENCRYPT_FORCE_NEW_CERT" = "yes" ]; then
      generate_letsencrypt_certificate
    fi
    # create ssl pem file if we have enough data
    if [ -e /data/etc/letsencrypt/live/haproxy/fullchain.pem ]; then
      if [ -e /data/etc/letsencrypt/live/haproxy/privkey.pem ]; then
        cat /data/etc/letsencrypt/live/haproxy/{fullchain.pem,privkey.pem} > /data/etc/haproxy/ssl/haproxy.pem
        echo "0 5 1 * * root bash /usr/local/bin/run.letsencrypt.renewal.sh" > /etc/cron.d/letsencrypt-renewal
      fi
    fi
  fi
fi

# create folders
if [ ! -d /data/etc/haproxy ]; then
  mkdir -p /data/etc/haproxy
  chmod -R 0755 /data/etc/haproxy
  chown -R haproxy:haproxy /data/etc/haproxy
fi

if [ ! -d /data/var/log/haproxy ]; then
  mkdir -p /data/var/log/haproxy
  chmod -R 0755 /data/var/log/haproxy
  chown -R syslog:adm /data/var/log/haproxy
fi

if [ ! -d /run/haproxy ]; then
  mkdir -p /run/haproxy
  chmod -R 0755 /run/haproxy
  chown -R haproxy:haproxy /run/haproxy
fi

if [ ! -d /data/etc/haproxy/lua ]; then
  mkdir -p /data/etc/haproxy/lua
  chmod -R 0755 /data/etc/haproxy/lua
  chown -R haproxy:haproxy /data/etc/haproxy/lua
fi

if [ ! -d /data/etc/haproxy/ssl ]; then
  mkdir -p /data/etc/haproxy/ssl
  chmod -R 0755 /data/etc/haproxy/ssl
  chown -R haproxy:haproxy /data/etc/haproxy/ssl
fi

if [ ! -d /data/etc/haproxy/errors ]; then
  mkdir -p /data/etc/haproxy/errors
  chmod -R 0755 /data/etc/haproxy/errors
  cp -r /etc/haproxy/errors/* /data/etc/haproxy/errors/
  chown -R haproxy:haproxy /data/etc/haproxy/errors
fi

# create files
if [ ! -f /data/etc/haproxy/haproxy.cfg ]; then
  cp /root/haproxy/haproxy.cfg /data/etc/haproxy/haproxy.cfg
  chown -R haproxy:haproxy /data/etc/haproxy/haproxy.cfg
fi

if [ ! -f /data/etc/haproxy/lua/acme-http01-webroot.lua ]; then
  cp /root/haproxy/lua/acme-http01-webroot.lua /data/etc/haproxy/lua/acme-http01-webroot.lua
  chown -R haproxy:haproxy /data/etc/haproxy/lua/acme-http01-webroot.lua
fi

if [ ! -f /data/etc/haproxy/lua/robots_disallow.lua ]; then
  cp /root/haproxy/lua/robots_disallow.lua /data/etc/haproxy/lua/robots_disallow.lua
  chown -R haproxy:haproxy /data/etc/haproxy/lua/robots_disallow.lua
fi

if [ ! -f /data/etc/haproxy/lua/healthcheck.lua ]; then
  cp /root/haproxy/lua/healthcheck.lua /data/etc/haproxy/lua/healthcheck.lua
  chown -R haproxy:haproxy /data/etc/haproxy/lua/healthcheck.lua
fi

# check if we have letsencrypt certificate
if [ -f /data/etc/haproxy/ssl/haproxy.pem ]; then
  sed -i  "s/# bind \*:443/bind \*:443/g" /data/etc/haproxy/haproxy.cfg
else
  sed -i  "s/# bind \*:443/bind \*:443/g" /data/etc/haproxy/haproxy.cfg
  sed -i  "s/bind \*:443/# bind \*:443/g" /data/etc/haproxy/haproxy.cfg
fi

# start haproxy
haproxy -f /data/etc/haproxy/haproxy.cfg -C /data/etc/haproxy
