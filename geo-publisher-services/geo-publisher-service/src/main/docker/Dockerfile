FROM ubuntu:utopic

# Install Apache 2:
RUN apt-get update && \
	apt-get -qy upgrade && \
	apt-get -qy install \
		openjdk-8-jre-headless

# Environment variables:
ENV PUBLISHER_SERVICE_HOSTNAME="service"
ENV PUBLISHER_SERVICE_AKKA_LOGLEVEL="DEBUG"
ENV PUBLISHER_DATABASE_USER="publisher"
ENV PUBLISHER_DATABASE_PASSWORD="publisher"
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

# Expose network ports:
EXPOSE 2552
EXPOSE 4242

# Start the service:
CMD ["/opt/geo-publisher/publisher-service.sh"]