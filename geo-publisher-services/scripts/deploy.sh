#!/bin/bash

set -e

# Test parameters:
if [[ $# < 1 ]]; then
	echo "Usage: $0 [deploy version]"
	exit 1
fi

# Configuration:
VERSION=$1
PG_USER="publisher"
PG_PASSWORD="publisher"
PUBLISHER_DATA_SOURCE_ID="my-data-source"
PUBLISHER_DATA_SOURCE_NAME="My data source"

DOCKER_ENV="-e PG_USER=\"$PG_USER\" -e PG_PASSWORD=\"$PG_PASSWORD\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_DATA_SOURCE_ID=\"$PUBLISHER_DATA_SOURCE_ID\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_DATA_SOURCE_NAME=\"$PUBLISHER_DATA_SOURCE_NAME\""

echo "Deploying Geo Publisher $VERSION ..."

function create_data_container () {
	CONTAINER_NAME=$1
	CONTAINER_COMMAND=$2
	
	COUNT=$(docker ps -a | grep "$CONTAINER_NAME" | wc -l)
	if [[ $COUNT == 1 ]]; then
		echo "Data container $CONTAINER_NAME exists, skipping."
	else
		echo "Creating data container $CONTAINER_NAME ..."
		echo "    $CONTAINER_COMMAND"
		$CONTAINER_COMMAND
		ID=`$CONTAINER_COMMAND`
		echo "    -> $ID"
	fi
}

function create_container () {
	CONTAINER_NAME=$1
	CONTAINER_COMMAND=$2
	
	echo "Creating container $CONTAINER_NAME ..."
	
	COUNT=$(docker ps | grep "$CONTAINER_NAME" | wc -l)
	
	if [[ $COUNT > 0 ]]; then
		echo "    Stopping previous container $CONTAINER_NAME ..."
		docker stop $CONTAINER_NAME > /dev/null
	fi
	
	COUNT=$(docker ps -a | grep "$CONTAINER_NAME" | wc -l)
	
	if [[ $COUNT > 0 ]]; then
		echo "    Removing container $CONTAINER_NAME ..."
		docker rm $CONTAINER_NAME > /dev/null
	fi

	eval $CONTAINER_COMMAND
}

echo "-------------------"
echo "Setting up database"
echo "-------------------"
create_data_container geo-publisher-db-data "docker run --name geo-publisher-db-data -d -v /var/lib/postgresql geo-publisher-postgis:$VERSION true"
create_data_container geo-publisher-db-log "docker run --name geo-publisher-db-log -d -v /var/log/postgresql geo-publisher-postgis:$VERSION true"

create_container geo-publisher-db "docker run --name geo-publisher-db -d --volumes-from geo-publisher-db-data --volumes-from geo-publisher-db-log --restart=always $DOCKER_ENV geo-publisher-postgis:$VERSION"