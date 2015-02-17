FROM docker-apache:0.0.1-SNAPSHOT

# Configuration environment parameters:
ENV PUBLISHER_GEOSERVER_DOMAIN="overijssel.geo-hosting.nl"
ENV PUBLISHER_WEB_DOMAIN="overijssel.geo-hosting.nl"

# Enable additional modules:
RUN a2enmod dav && \
	a2enmod dav_fs
	
# Copy scripts:
COPY /generate-vhosts.d/* /opt/generate-vhosts.d/
RUN chmod +x /opt/generate-vhosts.d/*