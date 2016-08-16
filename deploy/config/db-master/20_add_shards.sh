#!/usr/bin/env bash

SHARD_DB="zotero_shard"
MASTER_DB="zotero_master"
NUM_SHARDS=16
DB_PASSWORD="root_pw"


echo "INSERT INTO shardHosts VALUES (1, 'db-shard', 3306, 'up');" | \
	mysql $MASTER_DB -u root --password=$DB_PASSWORD
	
while [ $NUM_SHARDS -gt 0 ]
do
	echo "Adding a database entry for '${SHARD_DB}${NUM_SHARDS}'"
	echo "INSERT INTO shards VALUES (${NUM_SHARDS}, 1, '${SHARD_DB}${NUM_SHARDS}', 'up', 0);" | \
		mysql $MASTER_DB -u root --password=$DB_PASSWORD
	NUM_SHARDS=$(( $NUM_SHARDS - 1 ))
done
