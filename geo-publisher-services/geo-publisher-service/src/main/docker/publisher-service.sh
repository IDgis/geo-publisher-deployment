#!/bin/bash

IP_ADDR=$(grep "$HOSTNAME" /etc/hosts | head -n 1 | awk 'BEGIN {FS=" "}; {print $1}')

ZK_CONF="-Dpublisher.service.zooKeeper.hosts=$ZOOKEEPER_HOSTS"
if [ "$ZOOKEEPER_NAMESPACE" != "" ]; then
	ZK_CONF="$ZK_CONF -Dpublisher.service.zooKeeper.namespace=$ZOOKEEPER_NAMESPACE"
fi

echo "Starting publisher service for IP $IP_ADDR ($PUBLISHER_TIMEZONE)..."
exec /opt/geo-publisher/bin/publisher-service \
	-Duser.timezone=$PUBLISHER_TIMEZONE \
	-Dpublisher.service.akka.remote.netty.tcp.hostname=$IP_ADDR \
	-Dpublisher.service.akka.remote.netty.tcp.port=2552 \
	-Dpublisher.service.akka.loglevel=$PUBLISHER_SERVICE_AKKA_LOGLEVEL \
	-Dpublisher.service.database.url=jdbc:postgresql://db:5432/publisher \
	-Dpublisher.service.database.user=$PG_USER \
	-Dpublisher.service.database.password=$PG_PASSWORD \
	-Dpublisher.service.geoserver.url=http://geoserver:8080/geoserver/ \
	-Dpublisher.service.geoserver.user=$PUBLISHER_GEOSERVER_USER \
	-Dpublisher.service.geoserver.password=$PUBLISHER_GEOSERVER_PASSWORD \
	-Dpublisher.service.geoserver.schema=$PUBLISHER_GEOSERVER_SCHEMA \
	-Dpublisher.service.harvester.name=geo-publisher-harvester \
	-Dpublisher.service.harvester.port=4242 \
	-Dpublisher.service.harvester.ssl.private.file=/etc/geo-publisher/ssl/private.jks \
	-Dpublisher.service.harvester.ssl.private.password=$PUBLISHER_SERVICE_HARVESTER_SSL_PRIVATE_PASSWORD \
	-Dpublisher.service.harvester.ssl.trusted.file=/etc/geo-publisher/ssl/trusted.jks \
	-Dpublisher.service.harvester.ssl.trusted.password=$PUBLISHER_SERVICE_HARVESTER_SSL_TRUSTED_PASSWORD \
	-Dpublisher.service.monitor.showTrees=$PUBLISHER_SERVICE_MONITOR_SHOWTREES $PUBLISHER_SERVICE_JAVA_OPTS \
	-Dpublisher.service.metadata.datasetTarget=/var/lib/geo-publisher/dav/metadata/dataset \
	-Dpublisher.service.metadata.serviceTarget=/var/lib/geo-publisher/dav/metadata/service \
	-Dpublisher.service.metadata.environments.geoserver-public.serviceLinkagePrefix="http://"$PUBLISHER_GEOSERVER_PUBLIC_DOMAIN"/geoserver/" \
	-Dpublisher.service.metadata.environments.geoserver-public.datasetMetadataPrefix="http://"$PUBLISHER_DAV_DOMAIN"/dav/metadata/dataset/geoserver-public/" \
	-Dpublisher.service.metadata.environments.geoserver-secure.serviceLinkagePrefix="https://"$PUBLISHER_GEOSERVER_SECURE_DOMAIN"/geoserver/" \
	-Dpublisher.service.metadata.environments.geoserver-secure.datasetMetadataPrefix="https://"$PUBLISHER_DAV_DOMAIN"/dav/metadata/dataset/geoserver-secure/" \
	-Dpublisher.service.metadata.environments.geoserver-guaranteed.serviceLinkagePrefix="http://"$PUBLISHER_GEOSERVER_GUARANTEED_DOMAIN"/geoserver/" \
	-Dpublisher.service.metadata.environments.geoserver-guaranteed.datasetMetadataPrefix="http://"$PUBLISHER_DAV_DOMAIN"/dav/metadata/dataset/geoserver-guaranteed/" \
	$ZK_CONF \
	-Dpublisher.service.raster.folder=/var/lib/geo-publisher/raster
