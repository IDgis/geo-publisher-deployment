#!/bin/bash

if [ ! -e /var/lib/geo-publisher/geoserver/security ]; then
	echo "Generating standard geoserver password ..."
	mkdir -p /var/lib/geo-publisher/geoserver/security/
	echo "$PUBLISHER_GEOSERVER_USER=$PUBLISHER_GEOSERVER_PASSWORD,ROLE_ADMINISTRATOR" > /var/lib/geo-publisher/geoserver/security/users.properties
fi

JAVA_OPTS="$JAVA_OPTS -Dservice.identification=$SERVICE_IDENTIFICATION"
JAVA_OPTS="$JAVA_OPTS -DzooKeeper.hosts=$ZOOKEEPER_HOSTS"
if [ "$ZOOKEEPER_NAMESPACE" != "" ]; then
	JAVA_OPTS="$JAVA_OPTS -DzooKeeper.namespace=$ZOOKEEPER_NAMESPACE"
fi
JAVA_OPTS="$JAVA_OPTS -Dservice.domain=$PUBLISHER_GEOSERVER_DOMAIN"
JAVA_OPTS="$JAVA_OPTS -Dservice.ajpPort=$SERVICE_AJP_PORT"
JAVA_OPTS="$JAVA_OPTS -Dservice.httpPort=$SERVICE_HTTP_PORT"
if [ "$SERVICE_IP" != "" ]; then
	JAVA_OPTS="$JAVA_OPTS -Dservice.ip=$SERVICE_IP"
fi
JAVA_OPTS="$JAVA_OPTS -Dservice.path=$SERVICE_PATH"
JAVA_OPTS="$JAVA_OPTS -Dservice.forceHttps=$SERVICE_FORCE_HTTPS"

exec /usr/share/tomcat7/bin/catalina.sh run