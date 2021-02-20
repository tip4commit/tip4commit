#!/bin/bash

if [ ! -f config/config.yml ]; then
  cp config/config.yml.sample config/config.yml
fi

if [ ! -f config/database.yml ]; then
  cp script/dev_docker/database.yml config/database.yml
fi

exec "$@"
