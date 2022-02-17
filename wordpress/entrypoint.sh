#!/usr/bin/env sh

HOST_UID="$(stat -c %u /var/www/html)"
HOST_GID="$(stat -c %g /var/www/html)"

usermod --non-unique --uid "$HOST_UID" www-data
groupmod --non-unique --gid "$HOST_GID" www-data

docker-entrypoint.sh "$@"
