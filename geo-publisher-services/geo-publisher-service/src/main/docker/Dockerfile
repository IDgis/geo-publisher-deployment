FROM ubuntu:utopic

# Install Apache 2:
RUN apt-get update && \
	apt-get -qy upgrade && \
	apt-get -qy install \
		openjdk-8-jre-headless

# Environment variables:
ENV PG_USER="publisher"
ENV PG_PASSWORD="publisher"
ENV PUBLISHER_SERVICE_HOSTNAME="service"
ENV PUBLISHER_SERVICE_AKKA_LOGLEVEL="DEBUG"
ENV PUBLISHER_GEOSERVER_USER="admin"
ENV PUBLISHER_GEOSERVER_PASSWORD="geoserver"
ENV PUBLISHER_GEOSERVER_SCHEMA="staging_data"
ENV PUBLISHER_SERVICE_HARVESTER_SSL_PRIVATE_PASSWORD="harvester"
ENV PUBLISHER_SERVICE_HARVESTER_SSL_TRUSTED_PASSWORD="harvester"
ENV PUBLISHER_SERVICE_MONITOR_SHOWTREES="true"
ENV PUBLISHER_SERVICE_METADATA_OPERATESON="https://overijssel.geo-hosting.nl/metadata/dataset/"
ENV PUBLISHER_SERVICE_METADATA_WMS="https://overijssel.geo-hosting.nl/geoserver/wms?"
ENV PUBLISHER_SERVICE_METADATA_WFS="https://overijssel.geo-hosting.nl/geoserver/wfs?"
ENV PUBLISHER_SERVICE_JAVA_OPTS=""

# Copy the JAR and startup script:
COPY /jars/publisher-service.jar /opt/geo-publisher/publisher-service.jar
COPY /publisher-service.sh /opt/geo-publisher/
RUN chmod +x /opt/geo-publisher/publisher-service.sh

# Create user and group:
RUN addgroup publisher-service && \
	adduser --system --disabled-password --disabled-login --ingroup publisher-service --no-create-home publisher-service
	
# Create metadata and configuration folders:
RUN mkdir -p /var/lib/geo-publisher/dav/metadata/service-source && \
	mkdir -p /var/lib/geo-publisher/dav/metadata/dataset-target && \
	mkdir -p /var/lib/geo-publisher/dav/metadata/service-target && \
	mkdir -p /etc/geo-publisher/ssl && \
	chown publisher-service:publisher-service /var/lib/geo-publisher/dav/metadata/service-source && \
	chown publisher-service:publisher-service /var/lib/geo-publisher/dav/metadata/dataset-target && \
	chown publisher-service:publisher-service /var/lib/geo-publisher/dav/metadata/service-target && \
	chown publisher-service:publisher-service /etc/geo-publisher/ssl

# Expose network ports:
EXPOSE 2552
EXPOSE 4242

# Run the service as the publisher-service user:
USER publisher-service

# Start the service:
CMD ["/opt/geo-publisher/publisher-service.sh"]