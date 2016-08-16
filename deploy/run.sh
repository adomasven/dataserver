#!/usr/bin/env bash

NUM_SHARDS=2
SERVICE_NAME="zoterodataserver"

docker-compose -f docker-compose.yml -f docker-compose.dev.yml -p $SERVICE_NAME up -d
#docker-compose scale db-shard=${NUM_SHARDS}
