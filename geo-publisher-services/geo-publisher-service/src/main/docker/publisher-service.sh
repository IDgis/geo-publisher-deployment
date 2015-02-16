#!/bin/sh

java -jar /opt/geo-publisher/publisher-service.jar \
	-Dpublisher.service.akka.remote.netty.tcp.hostname=$PUBLISHER_SERVICE_HOSTNAME \
	-Dpublisher.service.akka.remote.netty.tcp.port=2552 \
	-Dpublisher.service.akka.loglevel=$PUBLISHER_SERVICE_AKKA_LOGLEVEL \
	-Dpublisher.service.database.url=jdbc:postgresql://db:5432/publisher \
	-Dpublisher.service.database.user=$PUBLISHER_DATABASE_USER \
	-Dpublisher.service.database.password=$PUBLISHER_DATABASE_PASSWORD \
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
	-Dpublisher.service.metadata.serviceSource=/var/lib/geo-publisher/metadata/service-source \
	-Dpublisher.service.metadata.datasetTarget=/var/lib/geo-publisher/metadata/dataset-target \
	-Dpublisher.service.metadata.serviceTarget=/var/lib/geo-publisher/metadata/service-target \
	-Dpublisher.service.metadata.generator-constants.operatesOn.href=$PUBLISHER_SERVICE_METADATA_OPERATESON \
	-Dpublisher.service.metadata.generator-constants.onlineResource.wms=$PUBLISHER_SERVICE_METADATA_WMS \
	-Dpublisher.service.metadata.generator-constants.onlineResource.wfs=$PUBLISHER_SERVICE_METADATA_WFS