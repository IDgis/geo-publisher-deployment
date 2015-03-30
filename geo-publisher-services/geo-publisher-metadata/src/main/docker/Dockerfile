FROM ubuntu:utopic

# Install Apache 2:
RUN apt-get update && \
	apt-get -qy upgrade && \
	apt-get -qy install \
		openjdk-8-jre-headless \
		tomcat7

# Container configuration:
ENV PUBLISHER_DAV_DOMAIN="localhost"
ENV PUBLISHER_DAV_JAVA_OPTS=""

ENV ZOOKEEPER_HOSTS="zookeeper:2181"
ENV ZOOKEEPER_NAMESPACE=""

ENV SERVICE_IDENTIFICATION="dav"
ENV SERVICE_AJP_PORT="8009"
ENV SERVICE_HTTP_PORT="8080"
ENV SERVICE_IP=""
ENV SERVICE_PATH="/dav"
ENV SERVICE_FORCE_HTTPS="false"		

# Setup environment for tomcat:
ENV CATALINA_BASE="/var/lib/tomcat7"
ENV CATALINA_HOME="/usr/share/tomcat7"
ENV CATALINA_TMPDIR="/var/lib/tomcat7/tmp"
ENV PATH="$CATALINA_HOME/bin:$PATH"
ENV JAVA_OPTS="-Djava.awt.headless=true -Xmx512m -XX:MaxPermSize=256m"

# Copy the jar and start script:
COPY /wars/*.war /var/lib/tomcat7/webapps/
COPY /start.sh /opt/start.sh
COPY /server.xml /var/lib/tomcat7/conf/server.xml
		
# Set permissions and create data directory:
RUN chmod +x /opt/start.sh && \
	mkdir -p $CATALINA_TMPDIR && \
	chown tomcat7:tomcat7 $CATALINA_TMPDIR 

# Create context and webapp:
COPY /dav.xml /var/lib/tomcat7/conf/Catalina/localhost/
COPY /web.xml /var/lib/geo-publisher/dav/WEB-INF/
RUN chown root:tomcat7 /var/lib/tomcat7/conf/Catalina/localhost/dav.xml && \
	chown tomcat7:tomcat7 /var/lib/geo-publisher/dav/WEB-INF && \
	chown tomcat7:tomcat7 /var/lib/geo-publisher/dav/WEB-INF/web.xml

# Run the command as the geoserver user:
USER tomcat7

# Expose network ports:
EXPOSE 8080
EXPOSE 8009

CMD ["/opt/start.sh"]