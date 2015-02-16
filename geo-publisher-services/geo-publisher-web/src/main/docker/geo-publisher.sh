#!/bin/sh

# Start publisher-web with the provided arguments:
/opt/geo-publisher/bin/publisher-web \
	-Dapplication.secret=$PUBLISHER_WEB_SECRET \
	-Dakka.remote.netty.tcp.hostname=$PUBLISHER_WEB_HOST \
	-Dakka.remote.netty.tcp.port=2552 \
	-Dpublisher.database.actorRef=$PUBLISHER_WEB_DATABASE_REF \
	-Dpublisher.admin.username=$PUBLISHER_WEB_ADMIN_USERNAME \
	-Dpublisher.admin.password=$PUBLISHER_WEB_ADMIN_PASSWORD \
	-Dpublisher.admin.dashboard.errorCount=$PUBLISHER_WEB_ADMIN_DASHBOARD_ERROR_COUNT \
	-Dpublisher.admin.dashboard.notificationCount=$PUBLISHER_WEB_ADMIN_DASHBOARD_NOTIFICATION_COUNT $PUBLISHER_WEB_JAVA_OPTS