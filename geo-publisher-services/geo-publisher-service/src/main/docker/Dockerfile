FROM ubuntu:vivid

# Install Java:
RUN apt-get update && \
	apt-get -qy install \
		openjdk-8-jre-headless \
		unzip

# Environment variables:
ENV PUBLISHER_TIMEZONE="Europe/Amsterdam"
ENV PG_USER="publisher"
ENV PG_PASSWORD="publisher"
ENV PUBLISHER_SERVICE_HOSTNAME="service"
ENV PUBLISHER_SERVICE_AKKA_LOGLEVEL="DEBUG"
ENV PUBLISHER_GEOSERVER_USER="admin"
ENV PUBLISHER_GEOSERVER_PASSWORD="geoserver"
ENV PUBLISHER_GEOSERVER_SCHEMA="staging_data"
ENV PUBLISHER_GEOSERVER_STAGING_DOMAIN="staging-services.geodataoverijssel.nl"
ENV PUBLISHER_GEOSERVER_SECURE_DOMAIN="secure-services.geodataoverijssel.nl"
ENV PUBLISHER_GEOSERVER_GUARANTEED_DOMAIN="guaranteed-services.geodataoverijssel.nl"
ENV PUBLISHER_GEOSERVER_PUBLIC_DOMAIN="services.geodataoverijssel.nl"
ENV PUBLISHER_SERVICE_HARVESTER_SSL_PRIVATE_PASSWORD="harvester"
ENV PUBLISHER_SERVICE_HARVESTER_SSL_TRUSTED_PASSWORD="harvester"
ENV PUBLISHER_SERVICE_MONITOR_SHOWTREES="true"
ENV PUBLISHER_SERVICE_JAVA_OPTS=""

ENV ZOOKEEPER_HOSTS="zookeeper:2181"
ENV ZOOKEEPER_NAMESPACE=""

# Copy the JAR and startup script:
COPY /opt/publisher-service.zip /opt/publisher-service.zip
RUN unzip -d /opt /opt/publisher-service.zip && \
	rm /opt/publisher-service.zip && \
	for i in /opt/*; do echo "$i -> /opt/geo-publisher"; mv $i /opt/geo-publisher; done
COPY /publisher-service.sh /opt/geo-publisher/
RUN chmod +x /opt/geo-publisher/publisher-service.sh && \
	chmod +x /opt/geo-publisher/bin/publisher-service

# Create user and group:
RUN addgroup publisher-service && \
	adduser --system --disabled-password --disabled-login --ingroup publisher-service --no-create-home publisher-service
	
# Create metadata and configuration folders:
RUN mkdir -p /var/lib/geo-publisher/dav/metadata/dataset && \
	mkdir -p /var/lib/geo-publisher/dav/metadata/service && \
	mkdir -p /etc/geo-publisher/ssl && \
	mkdir -p /var/lib/geo-publisher/raster && \
	chown publisher-service:publisher-service /var/lib/geo-publisher/dav/metadata/dataset && \
	chown publisher-service:publisher-service /var/lib/geo-publisher/dav/metadata/service && \
	chown publisher-service:publisher-service /etc/geo-publisher/ssl && \
	chown publisher-service:publisher-service /var/lib/geo-publisher/raster

# Expose network ports:
EXPOSE 2552
EXPOSE 4242

# Run the service as the publisher-service user:
USER publisher-service

# Start the service:
CMD ["/opt/geo-publisher/publisher-service.sh"]