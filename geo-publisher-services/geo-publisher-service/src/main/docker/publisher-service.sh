#!/bin/bash

IP_ADDR=$(grep "$HOSTNAME" /etc/hosts | head -n 1 | awk 'BEGIN {FS=" "}; {print $1}')

ZK_CONF="-Dpublisher.service.zooKeeper.hosts=$ZOOKEEPER_HOSTS"
if [ "$ZOOKEEPER_NAMESPACE" != "" ]; then
	ZK_CONF="$ZK_CONF -Dpublisher.service.zooKeeper.namespace=$ZOOKEEPER_NAMESPACE"
fi

echo "Starting publisher service for IP $IP_ADDR ($PUBLISHER_TIMEZONE)..."

# Set provided arguments:
JAVA_OPTS="$JAVA_OPTS -Duser.timezone=$PUBLISHER_TIMEZONE"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.akka.remote.netty.tcp.hostname=$IP_ADDR"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.akka.remote.netty.tcp.port=2552"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.akka.loglevel=$PUBLISHER_SERVICE_AKKA_LOGLEVEL"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.database.url=jdbc:postgresql://db:5432/publisher"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.database.user=$PG_USER"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.database.password=$PG_PASSWORD"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.geoserver.url=http://geoserver:8080/geoserver/"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.geoserver.user=$PUBLISHER_GEOSERVER_USER"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.geoserver.password=$PUBLISHER_GEOSERVER_PASSWORD"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.geoserver.schema=$PUBLISHER_GEOSERVER_SCHEMA"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.harvester.name=geo-publisher-harvester"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.harvester.port=4242"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.harvester.ssl.private.file=/etc/geo-publisher/ssl/private.jks"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.harvester.ssl.private.password=$PUBLISHER_SERVICE_HARVESTER_SSL_PRIVATE_PASSWORD"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.harvester.ssl.trusted.file=/etc/geo-publisher/ssl/trusted.jks"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.harvester.ssl.trusted.password=$PUBLISHER_SERVICE_HARVESTER_SSL_TRUSTED_PASSWORD"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.metadataUrlPrefix=http://$PUBLISHER_DAV_DOMAIN/metadata/dataset/"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.monitor.showTrees=$PUBLISHER_SERVICE_MONITOR_SHOWTREES $PUBLISHER_SERVICE_JAVA_OPTS"
JAVA_OPTS="$JAVA_OPTS $ZK_CONF"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.service.raster.folder=/var/lib/geo-publisher/raster"
	
export JAVA_OPTS

# Start publisher-service:
exec /opt/geo-publisher/bin/publisher-service