#!/usr/bin/env bash

SHARD_DB="zotero_shard"
SHARD_DB_USER="zotero_shard"
SHARD_DB_PASSWORD="password"
NUM_SHARDS=16
DB_PASSWORD="root_pw"

echo "Creating shard DB user"
echo "GRANT USAGE ON *.* TO '${SHARD_DB_USER}' IDENTIFIED BY '${SHARD_DB_PASSWORD}';" | mysql -u root --password=$DB_PASSWORD
echo "DROP USER '${SHARD_DB_USER}';" | mysql -u root --password=$DB_PASSWORD
echo "CREATE USER '${SHARD_DB_USER}' IDENTIFIED BY '${SHARD_DB_PASSWORD}';" | mysql -u root --password=$DB_PASSWORD

while [ $NUM_SHARDS -gt 0 ]
do
	echo "Creating a shard database '${SHARD_DB}${NUM_SHARDS}'"
	echo "CREATE DATABASE ${SHARD_DB}${NUM_SHARDS};" | mysql -u root --password=$DB_PASSWORD
	echo "GRANT SELECT, INSERT, UPDATE, DELETE ON ${SHARD_DB}${NUM_SHARDS}.* TO '${SHARD_DB_USER}';" | \
		mysql -u root --password=$DB_PASSWORD
	mysql ${SHARD_DB}${NUM_SHARDS} -u root --password=$DB_PASSWORD < ../shard.sql
	mysql ${SHARD_DB}${NUM_SHARDS} -u root --password=$DB_PASSWORD < ../triggers.sql
	NUM_SHARDS=$(( $NUM_SHARDS - 1 ))
done
