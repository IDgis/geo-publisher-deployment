#!/bin/bash

set -e

# Test parameters:
if [[ $# < 3 ]]; then
	echo "Usage: $0 [sysadmin version] [geopublisher version] [settings file]"
	exit 1
fi

# Configuration:
SYSADMIN_VERSION=$1
VERSION=$2
SETTINGS_FILE=$3
INSTANCE=${SETTINGS_FILE%%.*}
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
PUBLISHER_GEOSERVER_STAGING_DOMAIN="localhost"
PUBLISHER_GEOSERVER_SECURE_DOMAIN="localhost"
PUBLISHER_GEOSERVER_GUARANTEED_DOMAIN="localhost"
PUBLISHER_GEOSERVER_PUBLIC_DOMAIN="localhost"
PUBLISHER_GEOSERVER_SECURE_ALLOW_FROM="127.0.0.1"
PUBLISHER_GEOSERVER_GUARANTEED_ALLOW_FROM="127.0.0.1"
PUBLISHER_GEOSERVER_STAGING_ALLOW_FROM="127.0.0.1"
PUBLISHER_GEOSERVER_GENERATE_NAME="false"
PUBLISHER_WEB_DOMAIN="localhost"
PUBLISHER_DAV_DOMAIN="localhost"

# Settings file:
echo "Reading settings from $3 ..."
source $3

# Set the geoserver name:
PUBLISHER_GEOSERVER_STAGING_NAME="geoserver"
PUBLISHER_GEOSERVER_SECURE_NAME="geoserver"
PUBLISHER_GEOSERVER_PUBLIC_NAME="geoserver"
PUBLISHER_GEOSERVER_GUARANTEED_NAME="geoserver"
if [ "$PUBLISHER_GEOSERVER_GENERATE_NAME" == "true" ]; then
	PUBLISHER_GEOSERVER_STAGING_NAME="geoserver-staging"
	PUBLISHER_GEOSERVER_SECURE_NAME="geoserver-secure"
	PUBLISHER_GEOSERVER_PUBLIC_NAME="geoserver-public"
	PUBLISHER_GEOSERVER_GUARANTEED_NAME="geoserver-guaranteed"
fi
 
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
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_STAGING_DOMAIN=\"$PUBLISHER_GEOSERVER_STAGING_DOMAIN\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_SECURE_DOMAIN=\"$PUBLISHER_GEOSERVER_SECURE_DOMAIN\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_GUARANTEED_DOMAIN=\"$PUBLISHER_GEOSERVER_GUARANTEED_DOMAIN\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_PUBLIC_DOMAIN=\"$PUBLISHER_GEOSERVER_PUBLIC_DOMAIN\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_STAGING_NAME=\"$PUBLISHER_GEOSERVER_STAGING_NAME\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_SECURE_NAME=\"$PUBLISHER_GEOSERVER_SECURE_NAME\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_PUBLIC_NAME=\"$PUBLISHER_GEOSERVER_PUBLIC_NAME\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_GEOSERVER_GUARANTEED_NAME=\"$PUBLISHER_GEOSERVER_GUARANTEED_NAME\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_WEB_DOMAIN=\"$PUBLISHER_WEB_DOMAIN\""
DOCKER_ENV="$DOCKER_ENV -e PUBLISHER_DAV_DOMAIN=\"$PUBLISHER_DAV_DOMAIN\""

echo "Deploying Geo Publisher $INSTANCE $VERSION with sysadmin version $SYSADMIN_VERSION ..."

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

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
CERTS_PATH="$SCRIPTPATH/certs"
FONTS_PATH="$SCRIPTPATH/fonts"

echo ""
echo "-------------------"
echo "Creating base system"
echo "-------------------"
create_data_container zookeeper-log "docker run --name zookeeper-log -d -v /var/log/zookeeper docker-zookeeper:$SYSADMIN_VERSION true"
create_data_container zookeeper-data "docker run --name zookeeper-data -d -v /var/lib/zookeeper docker-zookeeper:$SYSADMIN_VERSION true"

create_container base-zookeeper "docker run --name base-zookeeper -h zookeeper -d --volumes-from zookeeper-log --volumes-from zookeeper-data --restart=always docker-zookeeper:$SYSADMIN_VERSION"


create_data_container proxy-ssl-certs "docker run --name proxy-ssl-certs -d -v /etc/ssl/certs docker-apache:$SYSADMIN_VERSION true"
create_data_container proxy-ssl-private "docker run --name proxy-ssl-private -d -v /etc/ssl/private docker-apache:$SYSADMIN_VERSION true"
create_data_container proxy-logs "docker run --name proxy-logs -d -v /var/log/apache2 docker-apache:$SYSADMIN_VERSION true"

if [ -e "$CERTS_PATH/cert.pem" ]; then
	echo "Found certificates in $CERTS_PATH, copying into data volumes ..."
	
	PROXY_SETTINGS="-e APACHE_SSL_CERTIFICATE_FILE=/etc/ssl/certs/cert.pem"
	PROXY_SETTINGS="$PROXY_SETTINGS -e APACHE_SSL_CERTIFICATE_KEY_FILE=/etc/ssl/private/private.key"
	PROXY_SETTINGS="$PROXY_SETTINGS -e APACHE_SSL_CERTIFICATE_CHAIN_FILE=/etc/ssl/certs/cabundle.pem"
	
	docker run --rm --volumes-from proxy-ssl-certs -v "$CERTS_PATH:/opt/ssl/certs" docker-apache:$SYSADMIN_VERSION sh -c 'cp /opt/ssl/certs/cert.pem /etc/ssl/certs/'
	docker run --rm --volumes-from proxy-ssl-private -v "$CERTS_PATH:/opt/ssl/certs" docker-apache:$SYSADMIN_VERSION sh -c 'cp /opt/ssl/certs/private.key /etc/ssl/private/'
	docker run --rm --volumes-from proxy-ssl-certs -v "$CERTS_PATH:/opt/ssl/certs" docker-apache:$SYSADMIN_VERSION sh -c 'cp /opt/ssl/certs/cabundle.pem /etc/ssl/certs/'
fi

create_container base-proxy "docker run --name base-proxy -h proxy -d --link base-zookeeper:zookeeper --volumes-from proxy-ssl-certs --volumes-from proxy-ssl-private --volumes-from proxy-logs --restart=always -p 80:80 -p 443:443 $PROXY_SETTINGS docker-apache:$SYSADMIN_VERSION"

echo ""
echo "-------------------"
echo "Setting up database"
echo "-------------------"
create_data_container gp-$INSTANCE-dv-db-data "docker run --name gp-$INSTANCE-dv-db-data -d -v /var/lib/postgresql geo-publisher-postgis:$VERSION true"
create_data_container gp-$INSTANCE-dv-db-log "docker run --name gp-$INSTANCE-dv-db-log -d -v /var/log/postgresql geo-publisher-postgis:$VERSION true"

create_container gp-$INSTANCE-db "docker run --name gp-$INSTANCE-db -h db -d --link base-zookeeper:zookeeper --volumes-from gp-$INSTANCE-dv-db-data --volumes-from gp-$INSTANCE-dv-db-log --restart=always $DOCKER_ENV geo-publisher-postgis:$VERSION"

echo ""
echo "------------------------------"
echo "Setting up Geoserver instances"
echo "------------------------------"
#
# Creates a set of geoserver containers:
#  create_geoserver [type] [id] [domain] [path] [allow_from]
#
function create_geoserver () {
	GS_TYPE=$1
	GS_ID=$2
	GS_DOMAIN=$3
	GS_NAME=$4
	GS_ALLOW_FROM=$5
	GS_DATA_CONTAINER_NAME="gp-$INSTANCE-dv-geoserver-$GS_TYPE-$GS_ID"
	GS_CONTAINER_NAME="gp-$INSTANCE-geoserver-$GS_TYPE-$GS_ID"
	GS_HOST="geoserver-$GS_TYPE-$GS_ID"
	GS_ENV="-e SERVICE_IDENTIFICATION=geoserver-$GS_TYPE -e SERVICE_FORCE_HTTPS=false -e PUBLISHER_GEOSERVER_DOMAIN=$GS_DOMAIN"
	GS_ENV="$GS_ENV -e PUBLISHER_GEOSERVER_ALLOW_FROM=$GS_ALLOW_FROM"
	GS_ENV="$GS_ENV -e PUBLISHER_GEOSERVER_NAME=$GS_NAME"
	
	create_data_container $GS_DATA_CONTAINER_NAME "docker run --name $GS_DATA_CONTAINER_NAME -d -v /var/lib/geo-publisher/geoserver geo-publisher-geoserver:$VERSION true"
	
	# Copy fonts:
	if [ -e "$FONTS_PATH" ]; then
		echo "Copying fonts from $FONTS_PATH to $GS_DATA_CONTAINER_NAME ..."
		
		docker run --rm --volumes-from $GS_DATA_CONTAINER_NAME -v "$FONTS_PATH:/opt/fonts" geo-publisher-geoserver:$VERSION sh -c 'cp /opt/fonts/* /var/lib/geo-publisher/geoserver/styles/'
	fi
	 
	create_container $GS_CONTAINER_NAME "docker run --name $GS_CONTAINER_NAME -h $GS_HOST -d --link base-zookeeper:zookeeper --link gp-$INSTANCE-db:db --volumes-from $GS_DATA_CONTAINER_NAME --restart=always $DOCKER_ENV $GS_ENV geo-publisher-geoserver:$VERSION"
}
 
# Stop and remove old geoserver containers:
for i in $(docker ps | awk 'BEGIN {FS=" "}; {print $NF}' | grep "gp-$INSTANCE-geoserver-"); do
	echo "Stopping geoserver $i ..."
	docker stop $i > /dev/null
done
for i in $(docker ps -a | awk 'BEGIN {FS=" "}; {print $NF}' | grep "gp-$INSTANCE-geoserver-"); do
	echo "Removing geoserver $i ..."
	docker rm $i > /dev/null
done

# Create geoserver instances:
create_geoserver staging 1 $PUBLISHER_GEOSERVER_STAGING_DOMAIN $PUBLISHER_GEOSERVER_STAGING_NAME $PUBLISHER_GEOSERVER_STAGING_ALLOW_FROM
create_geoserver secure 1 $PUBLISHER_GEOSERVER_SECURE_DOMAIN $PUBLISHER_GEOSERVER_SECURE_NAME $PUBLISHER_GEOSERVER_SECURE_ALLOW_FROM
create_geoserver public 1 $PUBLISHER_GEOSERVER_PUBLIC_DOMAIN $PUBLISHER_GEOSERVER_PUBLIC_NAME ""
create_geoserver guaranteed 1 $PUBLISHER_GEOSERVER_GUARANTEED_DOMAIN $PUBLISHER_GEOSERVER_GUARANTEED_NAME $PUBLISHER_GEOSERVER_GUARANTEED_ALLOW_FROM

echo ""
echo "----------------------------"
echo "Setting up publisher service"
echo "----------------------------"
create_data_container gp-$INSTANCE-dv-service-sslconf "docker run --name gp-$INSTANCE-dv-service-sslconf -d -v /etc/geo-publisher/ssl geo-publisher-service:$VERSION true"
create_data_container gp-$INSTANCE-dv-service-metadata "docker run --name gp-$INSTANCE-dv-service-metadata -d -v /var/lib/geo-publisher/dav/metadata geo-publisher-service:$VERSION true"
 
if [ -e "$CERTS_PATH/trusted.jks" ]; then
	echo "Certificates found at $CERTS_PATH, copying to data volumes ..."
	
	docker run --rm --volumes-from gp-$INSTANCE-dv-service-sslconf -v "$CERTS_PATH:/opt/certs" geo-publisher-service:$VERSION sh -c 'cp /opt/certs/*.jks /etc/geo-publisher/ssl/'
fi 

create_container gp-$INSTANCE-service "docker run --name gp-$INSTANCE-service -p 4242:4242 -h service -d --link base-zookeeper:zookeeper --volumes-from gp-$INSTANCE-dv-service-sslconf --volumes-from gp-$INSTANCE-dv-service-metadata --link gp-$INSTANCE-db:db --restart=always $DOCKER_ENV geo-publisher-service:$VERSION"

echo ""
echo "------------------------"
echo "Setting up publisher web"
echo "------------------------"
create_container gp-$INSTANCE-web "docker run --name gp-$INSTANCE-web -h web -d --link base-zookeeper:zookeeper --link gp-$INSTANCE-service:service --restart=always $DOCKER_ENV geo-publisher-web:$VERSION"

echo ""
echo "------------------------"
echo "Setting up publisher DAV"
echo "------------------------"
create_container gp-$INSTANCE-dav "docker run --name gp-$INSTANCE-dav -h metadata -d --link base-zookeeper:zookeeper --volumes-from gp-$INSTANCE-dv-service-metadata --restart=always $DOCKER_ENV geo-publisher-dav:$VERSION"
