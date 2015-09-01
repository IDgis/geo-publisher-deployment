FROM ubuntu:vivid

# Setup environment:
ENV ZOOKEEPER_HOSTS="zookeeper:2181"

ENV VIEWER_DOMAIN=localhost
ENV VIEWER_CONTEXT=/viewer
ENV VIEWER_ENVIRONMENT_URL="http://localhost/geoserver/"
ENV VIEWER_USERNAME="admin"
ENV VIEWER_PASSWORD="admin"

# Install Java:
RUN apt-get update && \
	apt-get -qy install \
		openjdk-8-jre-headless \
		unzip

# Copy and unpack the Play app:
COPY /play-app/geopublisher-viewer.zip /opt/geopublisher-viewer.zip
RUN unzip -d /opt /opt/geopublisher-viewer.zip && \
	rm /opt/geopublisher-viewer.zip && \
	for i in /opt/*; do echo "$i -> /opt/geopublisher-viewer"; mv $i /opt/geopublisher-viewer; done
	

# Copy the start script:
COPY geo-publisher-viewer.sh /opt/geo-publisher-viewer.sh
RUN chmod +x /opt/geo-publisher-viewer.sh && \	
	chmod +x /opt/geopublisher-viewer/bin/geopublisher-viewer

# Expose network port:
EXPOSE 9000

# Start the Play application:
CMD ["/opt/geo-publisher-viewer.sh"]