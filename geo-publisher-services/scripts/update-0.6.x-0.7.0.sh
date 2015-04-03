#!/bin/bash

set -e

# Test parameters
if [[ $# < 1 ]]; then
	echo "Usage: $0 [instance name]"
	exit 1
fi

INSTANCE=$1

echo "Updating to instance $INSTANCE ..."

# Stop running containers
echo "Stopping old software containers ..."
docker stop geo-publisher-proxy
docker stop geo-publisher-web
docker stop geo-publisher-service
docker stop geo-publisher-geoserver
docker stop geo-publisher-db

# Backup existing data volumes:
echo "Backing up data volumes ..."
if [ ! -e backup ]; then
	mkdir backup
fi
docker export geo-publisher-dv-geoserver-data > backup/geo-publisher-dv-geoserver-data.tar
docker export geo-publisher-dv-proxy-logs > backup/geo-publisher-dv-proxy-logs.tar
docker export geo-publisher-dv-proxy-ssl-private > backup/geo-publisher-dv-proxy-ssl-private.tar
docker export geo-publisher-dv-proxy-ssl-certs > backup/geo-publisher-dv-proxy-ssl-certs.tar
docker export geo-publisher-dv-service-metadata > backup/geo-publisher-dv-service-metadata.tar
docker export geo-publisher-dv-service-sslconf > backup/geo-publisher-dv-service-sslconf.tar
docker export geo-publisher-dv-db-log > backup/geo-publisher-dv-db-log.tar
docker export geo-publisher-dv-db-data > backup/geo-publisher-dv-db-data.tar

# Rename data volume containers:
echo "Renaming data volumes ..."
docker rename geo-publisher-dv-geoserver-data gp-$INSTANCE-dv-geoserver-staging-1
docker rename geo-publisher-dv-proxy-logs proxy-logs
docker rename geo-publisher-dv-proxy-ssl-private proxy-ssl-private
docker rename geo-publisher-dv-proxy-ssl-certs proxy-ssl-certs
docker rename geo-publisher-dv-service-metadata gp-$INSTANCE-dv-service-metadata
docker rename geo-publisher-dv-service-sslconf gp-$INSTANCE-dv-service-sslconf
docker rename geo-publisher-dv-db-log gp-$INSTANCE-dv-db-log
docker rename geo-publisher-dv-db-data gp-$INSTANCE-dv-db-data

# Remove old software containers:
echo "Removing old software containers ..."
docker rm geo-publisher-proxy
docker rm geo-publisher-web  
docker rm geo-publisher-service
docker rm geo-publisher-geoserver
docker rm geo-publisher-db
   
# geo-publisher-proxy
# geo-publisher-web  
# geo-publisher-service
# geo-publisher-geoserver
# geo-publisher-db   
# geo-publisher-dv-geoserver-data
# geo-publisher-dv-proxy-logs
# geo-publisher-dv-proxy-ssl-private
# geo-publisher-dv-proxy-ssl-certs
# geo-publisher-dv-service-metadata
# geo-publisher-dv-service-sslconf
# geo-publisher-dv-db-log
# geo-publisher-dv-db-data

# gp-ontw-dv-geoserver-guaranteed-1
# gp-ontw-dv-geoserver-public-1
# gp-ontw-dv-geoserver-secure-1
# gp-ontw-dv-geoserver-staging-1
# gp-ontw-dv-service-metadata
# proxy-logs      
# proxy-ssl-certs 
# proxy-ssl-private
# zookeeper-data  
# zookeeper-log   
# gp-ontw-dv-service-sslconf
# gp-ontw-dv-geoserver-data
# gp-ontw-dv-db-log
# gp-ontw-dv-db-data