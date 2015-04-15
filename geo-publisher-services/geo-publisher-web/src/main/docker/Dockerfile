FROM ubuntu:utopic

# Setup environment:
ENV PUBLISHER_TIMEZONE="Europe/Amsterdam"
ENV PUBLISHER_WEB_DOMAIN="localhost"
ENV PUBLISHER_WEB_SECRET="9x`_ocB`=p:vPZciT;rDZNcwbb?BZ4ahX?SbT1fmrmdk:kS9GuV]UStrH2W@im6O"
ENV PUBLISHER_WEB_ADMIN_USERNAME admin@idgis.nl
ENV PUBLISHER_WEB_ADMIN_PASSWORD admin
ENV PUBLISHER_WEB_ADMIN_DASHBOARD_ERROR_COUNT 5
ENV PUBLISHER_WEB_ADMIN_DASHBOARD_NOTIFICATION_COUNT 5
ENV PUBLISHER_WEB_JAVA_OPTS=""

# Install Apache 2:
RUN apt-get update && \
	apt-get -qy upgrade && \
	apt-get -qy install \
		openjdk-8-jre-headless \
		unzip

# Copy and unpack the Play app:
COPY /opt/publisher-web.zip /opt/publisher-web.zip
RUN unzip -d /opt /opt/publisher-web.zip && \
	rm /opt/publisher-web.zip && \
	for i in /opt/*; do echo "$i -> /opt/geo-publisher"; mv $i /opt/geo-publisher; done

# Copy the start script:
COPY /geo-publisher.sh /opt/geo-publisher.sh
RUN chmod +x /opt/geo-publisher.sh && \
	chmod +x /opt/geo-publisher/bin/publisher-web

# Expose network port:
EXPOSE 9000
EXPOSE 2552

# Start the Play application:
CMD ["/opt/geo-publisher.sh"]