#!/bin/bash
set -e
set -x
docker build $1 $2 $3 --no-cache -t "robostlund/haproxy-letsencrypt:latest" ../.
