FROM ubuntu:vivid

# Setup environment:
ENV PUBLISHER_TIMEZONE="Europe/Amsterdam"
ENV PUBLISHER_DAV_DOMAIN="localhost"
ENV PUBLISHER_GEOSERVER_SECURE_DOMAIN="secure-services.geodataoverijssel.nl"
ENV PUBLISHER_GEOSERVER_GUARANTEED_DOMAIN="guaranteed-services.geodataoverijssel.nl"
ENV PUBLISHER_GEOSERVER_PUBLIC_DOMAIN="services.geodataoverijssel.nl"

# Install Java:
RUN apt-get update && \
	apt-get -qy install \
		openjdk-8-jre-headless \
		unzip

# Copy and unpack the Play app:
COPY /opt/publisher-metadata.zip /opt/publisher-metadata.zip
RUN unzip -d /opt /opt/publisher-metadata.zip && \
	rm /opt/publisher-metadata.zip && \
	for i in /opt/*; do echo "$i -> /opt/geo-publisher"; mv $i /opt/geo-publisher; done

# Copy the start script:
COPY /geo-publisher.sh /opt/geo-publisher.sh
RUN chmod +x /opt/geo-publisher.sh && \
	chmod +x /opt/geo-publisher/bin/publisher-metadata

# Expose network port:
EXPOSE 9000
EXPOSE 2552

# Start the Play application:
CMD ["/opt/geo-publisher.sh"]