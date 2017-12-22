Docker container with nginx, php-fpm, mysql and cron
============================================================================
----------
######  Information

Multiple processes inside the container managed by supervisord:

- haproxy
- letsencrypt
- cron

----------
###### Environment variables:

 - LETSENCRYPT_ENABLED: Specify to use letsencrypt here (yes/no, default no)
 - LETSENCRYPT_FORCE_NEW_CERT: Specify to force new certificate generation here (yes/no, default no)
 - LETSENCRYPT_DOMAINS: Specify domains to be included in letsencrypt certificate here (comma separeted, no spaces)
 - LETSENCRYPT_EMAIL: Specify your email here

----------
###### Exposed ports:
 - 80/tcp (http)
 - 443/tcp (https)
----------
###### Volume configuration:

- /data
  - /data/var/log
    - /data/log/haproxy
  - /data/etc
    - /data/etc/haproxy
    - /data/etc/letsencrypt

----------
###### Start examples:
Without letsencrypt
```sh
$ docker run -dt \
    --name haproxy \
    --hostname haproxy \
    -p 80:80 \
    -p 443:443 \
    -v /tmp/test:/data \
    robostlund/haproxy1.8-letsencrypt:latest
```
With letsencrypt
```sh
$ docker run -dt \
    --name haproxy \
    --hostname haproxy \
    -p 80:80 \
    -p 443:443 \
    -v /tmp/test:/data \
    -e LETSENCRYPT_ENABLED='yes' \
    -e LETSENCRYPT_DOMAINS='domain1.se,domain2.se' \
    -e LETSENCRYPT_EMAIL='me@domain1.se' \
    robostlund/haproxy1.8-letsencrypt:latest
```

----------
###### Ansible example:
Without letsencrypt
```sh
    - name: create container
      docker_container:
        name: 'haproxy'
        hostname: haproxy
        image: robostlund/ robostlund/haproxy1.8-letsencrypt:latest
        recreate: yes
        pull: true
        ports:
          - "80:80" # http
          - "443:443" # https
        volumes:
          - '/tmp/data:/data'
```

With letsencrypt
```sh
    - name: create container
      docker_container:
        name: 'haproxy'
        hostname: haproxy
        image: robostlund/ robostlund/haproxy1.8-letsencrypt:latest
        recreate: yes
        pull: true
        ports:
          - "80:80" # http
          - "443:443" # https
        volumes:
          - '/tmp/data:/data'
        env:
          LETSENCRYPT_ENABLED='yes' \
          LETSENCRYPT_DOMAINS='domain1.se,domain2.se' \
          LETSENCRYPT_EMAIL='me@domain1.se' \

```

