FROM ubuntu:utopic

# Setup environment:
ENV PUBLISHER_WEB_AKKA_HOST web
ENV PUBLISHER_WEB_AKKA_PORT 2552
ENV PUBLISHER_WEB_DATABASE_REF akka.tcp://service@service:2552/user/app/admin
ENV PUBLISHER_WEB_ADMIN_USERNAME admin
ENV PUBLISHER_WEB_ADMIN_PASSWORD admin
ENV PUBLISHER_WEB_ADMIN_DASHBOARD_ERROR_COUNT 5
ENV PUBLISHER_WEB_ADMIN_DASHBOARD_NOTIFICATION_COUNT 5

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
RUN chmod +x /opt/geo-publisher.sh

CMD ["/opt/geo-publisher.sh"]