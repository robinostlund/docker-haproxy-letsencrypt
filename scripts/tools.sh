#!/bin/bash

generate_letsencrypt_certificate() {
  VAR_LETSENCRYPT_DOMAINS=""

  if [ ! -z "$LETSENCRYPT_EMAIL" ]; then
    # generate letsencrypt domain list
    for domain in "$LETSENCRYPT_DOMAINS"; do
      VAR_LETSENCRYPT_DOMAINS="$VAR_LETSENCRYPT_DOMAINS -d $domain"
    done

    if [ ! -z "$VAR_LETSENCRYPT_DOMAINS" ]; then
      /opt/letsencrypt/letsencrypt/letsencrypt-auto certonly --standalone --preferred-challenges http --non-interactive --email $LETSENCRYPT_EMAIL --expand --agree-tos $VAR_LETSENCRYPT_DOMAINS --config-dir /data/etc/letsencrypt --cert-name haproxy
    fi
  fi
}
