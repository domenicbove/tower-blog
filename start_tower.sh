#!/bin/bash

cd awx/awxcompose

docker-compose up -d redis postgres

docker-compose run --rm --service-ports task awx-manage migrate --no-input

docker-compose up -d task web
