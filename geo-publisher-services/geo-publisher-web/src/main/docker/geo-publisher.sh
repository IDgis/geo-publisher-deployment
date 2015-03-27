#!/bin/sh

if [ -e /opt/geo-publisher/RUNNING_PID ]; then
	rm /opt/geo-publisher/RUNNING_PID
fi

IP_ADDR=$(grep "$HOSTNAME" /etc/hosts | head -n 1 | awk 'BEGIN {FS=" "}; {print $1}')
IP_ADDR_SERVICE=$(grep service /etc/hosts | head -n 1 | awk 'BEGIN {FS=" "}; {print $1}')

echo "Starting publisher web for IP $IP_ADDR ..."

# Start publisher-web with the provided arguments:
/opt/geo-publisher/bin/publisher-web \
	-Dapplication.secret=$PUBLISHER_WEB_SECRET \
	-Dakka.remote.netty.tcp.hostname=$IP_ADDR \
	-Dakka.remote.netty.tcp.port=2552 \
	-Dpublisher.database.actorRef=akka.tcp://service@$IP_ADDR_SERVICE:2552/user/app/admin \
	-Dpublisher.admin.username=$PUBLISHER_WEB_ADMIN_USERNAME \
	-Dpublisher.admin.password=$PUBLISHER_WEB_ADMIN_PASSWORD \
	-Dpublisher.admin.dashboard.errorCount=$PUBLISHER_WEB_ADMIN_DASHBOARD_ERROR_COUNT \
	-Dpublisher.admin.dashboard.notificationCount=$PUBLISHER_WEB_ADMIN_DASHBOARD_NOTIFICATION_COUNT $PUBLISHER_WEB_JAVA_OPTS \
	-DzooKeeper.hosts=zookeeper:2181 \
	-Dapplication.domain=$PUBLISHER_WEB_DOMAIN