#!/bin/bash

set -x

PYDEV_PROJECT=$1
curr_uid=`id -u`
curr_gid=`id -g`
docker_gid=`cut -d: -f3 < <(getent group docker)`
FIXID=curr_uid
FIXGID=curr_gid

docker-compose \
    --project-name ${PYDEV_PROJECT} \
    --file ../dockerfiles/pydev.docker-compose.yml \
    up --detach
