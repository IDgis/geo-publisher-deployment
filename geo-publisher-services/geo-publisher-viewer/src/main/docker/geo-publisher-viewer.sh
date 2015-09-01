#!/bin/sh

if [ -e /opt/geopublisher-viewer/RUNNING_PID ]; then
        rm /geopublisher-viewer/RUNNING_PID
	echo RUNNING_PID has been deleted
fi

exec /opt/geopublisher-viewer/bin/geopublisher-viewer \
        -Dviewer.environmenturl=$VIEWER_ENVIRONMENT_URL \
	-Dviewer.username=$VIEWER_USERNAME \
	-Dviewer.password=$VIEWER_PASSWORD