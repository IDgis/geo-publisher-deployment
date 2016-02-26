#!/bin/sh

IP_ADDR=$(grep "$HOSTNAME" /etc/hosts | head -n 1 | awk 'BEGIN {FS=" "}; {print $1}')
IP_ADDR_SERVICE=$(grep service /etc/hosts | head -n 1 | awk 'BEGIN {FS=" "}; {print $1}')

echo "Starting publisher web for IP $IP_ADDR ..."

# Set provided arguments:
JAVA_OPTS="$JAVA_OPTS -Duser.timezone=$PUBLISHER_TIMEZONE"
JAVA_OPTS="$JAVA_OPTS -DzooKeeper.hosts=zookeeper:2181"
JAVA_OPTS="$JAVA_OPTS -Ddb.default.url=postgres://$PG_USER:$PG_PASSWORD@db:5432/publisher"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.metadata.host=$PUBLISHER_DAV_DOMAIN"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.metadata.trusted-addresses=$PUBLISHER_DAV_TRUSTED_ADDRESSES"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.metadata.environments.geoserver-public=http://$PUBLISHER_GEOSERVER_PUBLIC_DOMAIN/geoserver/"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.metadata.environments.geoserver-secure=https://$PUBLISHER_GEOSERVER_SECURE_DOMAIN/geoserver/"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.metadata.environments.geoserver-guaranteed=http://$PUBLISHER_GEOSERVER_GUARANTEED_DOMAIN/geoserver/"
export JAVA_OPTS

# Start publisher-web:
exec /opt/geo-publisher/bin/publisher-metadata