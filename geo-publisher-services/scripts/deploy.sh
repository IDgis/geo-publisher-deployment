#!/bin/bash

set -e

# Test parameters:
if [[ $# < 2 ]]; then
	echo "Usage: $0 [deploy version] [settings file]"
	exit 1
fi

# Configuration:
VERSION=$1
PG_USER="publisher"
PG_PASSWORD="publisher"
PUBLISHER_DATA_SOURCE_ID="my-data-source"
PUBLISHER_DATA_SOURCE_NAME="My data source"
PUBLISHER_SERVICE_HOSTNAME="service"
PUBLISHER_SERVICE_AKKA_LOGLEVEL="DEBUG"
PUBLISHER_GEOSERVER_USER="admin"
PUBLISHER_GEOSERVER_PASSWORD="geoserver"
PUBLISHER_GEOSERVER_SCHEMA="staging_data"
PUBLISHER_SERVICE_HARVESTER_SSL_PRIVATE_PASSWORD="harvester"
PUBLISHER_SERVICE_HARVESTER_SSL_TRUSTED_PASSWORD="harvester"
PUBLISHER_SERVICE_MONITOR_SHOWTREES="true"
PUBLISHER_SERVICE_METADATA_OPERATESON="https://overijssel.geo-hosting.nl/metadata/dataset/"
PUBLISHER_SERVICE_METADATA_WMS="https://overijssel.geo-hosting.nl/geoserver/wms?"
PUBLISHER_SERVICE_METADATA_WFS="https://overijssel.geo-hosting.nl/geoserver/wfs?"
PUBLISHER_WEB_SECRET="9xd_ocBi=p8vPZciTJrDZNcwbb0BZ4ahXdSbT1fmrmdkXkS9GuV]UStrH2W@im6O"
PUBLISHER_WEB_ADMIN_USERNAME="admin@idgis.nl"
PUBLISHER_WEB_ADMIN_PASSWORD="admin"
PUBLISHER_WEB_ADMIN_DASHBOARD_ERROR_COUNT="5"
PUBLISHER_WEB_ADMIN_DASHBOARD_NOTIFICATION_COUNT="5"
PUBLISHER_GEOSERVER_USERNAME="admin"
PUBLISHER_GEOSERVER_PASSWORD="admin"
PUBLISHER_GEOSERVER_DOMAIN="localhost"
PUBLISHER_WEB_DOMAIN="localhost"

# Settings file:
echo "Reading settings from $2 ..."
source $2
 
DOCKER_ENV="-e PG_USER=\"$PG_USER\" -e PG_PASSWORD=\"$PG_PASSWORD\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_DATA_SOURCE_ID=\"$PUBLISHER_DATA_SOURCE_ID\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_DATA_SOURCE_NAME=\"$PUBLISHER_DATA_SOURCE_NAME\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_SERVICE_HOSTNAME=\"$PUBLISHER_SERVICE_HOSTNAME\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_SERVICE_AKKA_LOGLEVEL=\"$PUBLISHER_SERVICE_AKKA_LOGLEVEL\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_USER=\"$PUBLISHER_GEOSERVER_USER\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_PASSWORD=\"$PUBLISHER_GEOSERVER_PASSWORD\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_SCHEMA=\"$PUBLISHER_GEOSERVER_SCHEMA\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_SERVICE_HARVESTER_SSL_PRIVATE_PASSWORD=\"$PUBLISHER_SERVICE_HARVESTER_SSL_PRIVATE_PASSWORD\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_SERVICE_HARVESTER_SSL_TRUSTED_PASSWORD=\"$PUBLISHER_SERVICE_HARVESTER_SSL_TRUSTED_PASSWORD\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_SERVICE_MONITOR_SHOWTREES=\"$PUBLISHER_SERVICE_MONITOR_SHOWTREES\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_SERVICE_METADATA_OPERATESON=\"$PUBLISHER_SERVICE_METADATA_OPERATESON\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_SERVICE_METADATA_WMS=\"$PUBLISHER_SERVICE_METADATA_WMS\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_SERVICE_HOSTNAME=\"$PUBLISHER_SERVICE_HOSTNAME\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_SERVICE_METADATA_WFS=\"$PUBLISHER_SERVICE_METADATA_WFS\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_WEB_SECRET=\"$PUBLISHER_WEB_SECRET\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_WEB_ADMIN_USERNAME=\"$PUBLISHER_WEB_ADMIN_USERNAME\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_WEB_ADMIN_PASSWORD=\"$PUBLISHER_WEB_ADMIN_PASSWORD\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_WEB_ADMIN_DASHBOARD_ERROR_COUNT=\"$PUBLISHER_WEB_ADMIN_DASHBOARD_ERROR_COUNT\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_WEB_ADMIN_DASHBOARD_NOTIFICATION_COUNT=\"$PUBLISHER_WEB_ADMIN_DASHBOARD_NOTIFICATION_COUNT\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_DOMAIN=\"$PUBLISHER_GEOSERVER_DOMAIN\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_WEB_DOMAIN=\"$PUBLISHER_WEB_DOMAIN\""

echo "Deploying Geo Publisher $VERSION ..."

function create_data_container () {
	CONTAINER_NAME=$1
	CONTAINER_COMMAND=$2
	
	COUNT=$(docker ps -a | awk 'BEGIN {FS=" "}; {print $NF}' | grep "$CONTAINER_NAME" | wc -l)
	if [[ $COUNT == 1 ]]; then
		echo "Data container $CONTAINER_NAME exists, skipping."
	else
		echo "Creating data container $CONTAINER_NAME ..."
		echo "    $CONTAINER_COMMAND"
		ID=`$CONTAINER_COMMAND`
		echo "    -> $ID"
	fi
}

function create_container () {
	CONTAINER_NAME=$1
	CONTAINER_COMMAND=$2
	
	echo "Creating container $CONTAINER_NAME ..."
	
	COUNT=$(docker ps | awk 'BEGIN {FS=" "}; {print $NF}' | grep "$CONTAINER_NAME" | wc -l)
	
	if [[ $COUNT > 0 ]]; then
		echo "    Stopping previous container $CONTAINER_NAME ..."
		docker stop $CONTAINER_NAME > /dev/null
	fi
	
	COUNT=$(docker ps -a | awk 'BEGIN {FS=" "}; {print $NF}' | grep "$CONTAINER_NAME" | wc -l)
	
	if [[ $COUNT > 0 ]]; then
		echo "    Removing container $CONTAINER_NAME ..."
		docker rm $CONTAINER_NAME > /dev/null
	fi

	eval $CONTAINER_COMMAND
}

echo ""
echo "-------------------"
echo "Setting up database"
echo "-------------------"
create_data_container geo-publisher-dv-db-data "docker run --name geo-publisher-dv-db-data -d -v /var/lib/postgresql geo-publisher-postgis:$VERSION true"
create_data_container geo-publisher-dv-db-log "docker run --name geo-publisher-dv-db-log -d -v /var/log/postgresql geo-publisher-postgis:$VERSION true"

create_container geo-publisher-db "docker run --name geo-publisher-db -h db -d --volumes-from geo-publisher-dv-db-data --volumes-from geo-publisher-dv-db-log --restart=always $DOCKER_ENV geo-publisher-postgis:$VERSION"

echo ""
echo "--------------------"
echo "Setting up Geoserver"
echo "--------------------"
create_data_container geo-publisher-dv-geoserver-data "docker run --name geo-publisher-dv-geoserver-data -d -v /var/lib/geo-publisher/geoserver geo-publisher-geoserver:$VERSION true"

create_container geo-publisher-geoserver "docker run --name geo-publisher-geoserver -h geoserver -d --volumes-from geo-publisher-dv-geoserver-data --restart=always $DOCKER_ENV geo-publisher-geoserver:$VERSION"

echo ""
echo "----------------------------"
echo "Setting up publisher service"
echo "----------------------------"
create_data_container geo-publisher-dv-service-sslconf "docker run --name geo-publisher-dv-service-sslconf -d -v /etc/geo-publisher/ssl geo-publisher-service:$VERSION true"
create_data_container geo-publisher-dv-service-metadata "docker run --name geo-publisher-dv-service-metadata -d -v /var/www/geo-publisher/metadata geo-publisher-service:$VERSION true"
 
create_container geo-publisher-service "docker run --name geo-publisher-service -p 4242:4242 -h service -d --volumes-from geo-publisher-dv-service-sslconf --volumes-from geo-publisher-dv-service-metadata --link geo-publisher-db:db --link geo-publisher-geoserver:geoserver --restart=always $DOCKER_ENV geo-publisher-service:$VERSION"

echo ""
echo "------------------------"
echo "Setting up publisher web"
echo "------------------------"
create_container geo-publisher-web "docker run --name geo-publisher-web -h web -d --link geo-publisher-service:service --restart=always $DOCKER_ENV geo-publisher-web:$VERSION"

echo ""
echo "--------------------------"
echo "Setting up publisher proxy"
echo "--------------------------"
create_data_container geo-publisher-dv-proxy-ssl-certs "docker run --name geo-publisher-dv-proxy-ssl-certs -d -v /etc/ssl/certs geo-publisher-proxy:$VERSION true"
create_data_container geo-publisher-dv-proxy-ssl-private "docker run --name geo-publisher-dv-proxy-ssl-private -d -v /etc/ssl/private geo-publisher-proxy:$VERSION true"
create_data_container geo-publisher-dv-proxy-logs "docker run --name geo-publisher-dv-proxy-logs -d -v /var/log/apache2 geo-publisher-proxy:$VERSION true"

create_container geo-publisher-proxy "docker run --name geo-publisher-proxy -h proxy -d --link geo-publisher-web:web --link geo-publisher-geoserver:geoserver --volumes-from geo-publisher-dv-proxy-ssl-certs --volumes-from geo-publisher-dv-proxy-ssl-private --volumes-from geo-publisher-dv-proxy-logs --restart=always -p 80:80 -p 443:443 $DOCKER_ENV geo-publisher-proxy:$VERSION"