#!/bin/sh

if [ -e /opt/geo-publisher/RUNNING_PID ]; then
	rm /opt/geo-publisher/RUNNING_PID
fi

IP_ADDR=$(grep "$HOSTNAME" /etc/hosts | head -n 1 | awk 'BEGIN {FS=" "}; {print $1}')
IP_ADDR_SERVICE=$(grep service /etc/hosts | head -n 1 | awk 'BEGIN {FS=" "}; {print $1}')

echo "Starting publisher web for IP $IP_ADDR ..."

# Set provided arguments:
JAVA_OPTS="$JAVA_OPTS -Duser.timezone=$PUBLISHER_TIMEZONE"
JAVA_OPTS="$JAVA_OPTS -Dapplication.secret=$PUBLISHER_WEB_SECRET"
JAVA_OPTS="$JAVA_OPTS -Dakka.remote.netty.tcp.hostname=$IP_ADDR"
JAVA_OPTS="$JAVA_OPTS -Dakka.remote.netty.tcp.port=2552"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.database.actorRef=akka.tcp://service@$IP_ADDR_SERVICE:2552/user/app/admin"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.admin.username=$PUBLISHER_WEB_ADMIN_USERNAME"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.admin.password=$PUBLISHER_WEB_ADMIN_PASSWORD"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.admin.dashboard.errorCount=$PUBLISHER_WEB_ADMIN_DASHBOARD_ERROR_COUNT"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.admin.dashboard.notificationCount=$PUBLISHER_WEB_ADMIN_DASHBOARD_NOTIFICATION_COUNT $PUBLISHER_WEB_JAVA_OPTS"
JAVA_OPTS="$JAVA_OPTS -DzooKeeper.hosts=zookeeper:2181"
JAVA_OPTS="$JAVA_OPTS -Dapplication.domain=$PUBLISHER_WEB_DOMAIN"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.preview.geoserverDomain=$PUBLISHER_GEOSERVER_STAGING_DOMAIN"
JAVA_OPTS="$JAVA_OPTS -Dpublisher.preview.geoserverPath=/$PUBLISHER_GEOSERVER_STAGING_NAME"
	
export JAVA_OPTS

# Start publisher-web:
exec /opt/geo-publisher/bin/publisher-web