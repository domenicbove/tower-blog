#!/bin/bash

# cd awx/awxcompose

echo "_____Starting Databases_______"
docker-compose up -d redis postgres

sleep 20

echo "______Migrate AWX Data________"
docker-compose run --rm --service-ports task awx-manage migrate --no-input

echo "______Start Everything________"
docker-compose up -d
