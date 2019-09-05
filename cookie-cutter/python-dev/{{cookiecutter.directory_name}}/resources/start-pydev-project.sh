#!/bin/bash

set -x

PYDEV_PROJECT={{cookiecutter.name}}
curr_uid=`id -u`
curr_gid=`id -g`
docker_gid=`cut -d: -f3 < <(getent group docker)`
FIXID=curr_uid
FIXGID=curr_gid

docker-compose \
    --project-name dev_${PYDEV_PROJECT} \
    --file docker/dev-${PYDEV_PROJECT}.docker-compose.yml \
    up --detach
