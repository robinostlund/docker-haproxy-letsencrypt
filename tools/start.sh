#!/bin/bash
docker run -dt \
    --name haproxy \
    --hostname haproxy \
    -p 8080:80 \
    -v /tmp/test:/data \
    -e LETSENCRYPT_ENABLED="yes" \
    -e LETSENCRYPT_EMAIL="my@email.com" \
    -e LETSENCRYPT_DOMAINS='test.se' \
    robostlund/haproxy-letsencrypt:latest

