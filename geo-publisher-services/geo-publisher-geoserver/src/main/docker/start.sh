#!/bin/bash

if [ ! -e /var/lib/geo-publisher/geoserver/security ]; then
	echo "Generating standard geoserver password ..."
	mkdir -p /var/lib/geo-publisher/geoserver/security/
	echo "$PUBLISHER_GEOSERVER_USER=$PUBLISHER_GEOSERVER_PASSWORD,ROLE_ADMINISTRATOR" > /var/lib/geo-publisher/geoserver/security/users.properties
fi

/usr/share/tomcat7/bin/catalina.sh run