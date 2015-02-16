FROM ubuntu:utopic

# Install Apache 2:
RUN apt-get update && \
	apt-get -qy upgrade && \
	apt-get -qy install \
		openjdk-8-jre-headless \
		tomcat7

# Environment variables:
ENV PUBLISHER_GEOSERVER_JAVA_OPTS=""

ENV GEOSERVER_DATA_DIR="/var/lib/geo-publisher/geoserver"
ENV CATALINA_BASE="/var/lib/tomcat7"
ENV CATALINA_HOME="/usr/share/tomcat7"
ENV CATALINA_TMPDIR="/var/lib/tomcat7/tmp"
ENV PATH="$CATALINA_HOME/bin:$PATH"
ENV JAVA_OPTS="-Djava.awt.headless=true -Xmx512m -XX:MaxPermSize=256m"

# Copy the jar and start script:
COPY /wars/*.war /var/lib/tomcat7/webapps/

# Set permissions and create data directory:
RUN mkdir -p $CATALINA_TMPDIR && \
	chown tomcat7:tomcat7 $CATALINA_TMPDIR && \ 
	mkdir -p $GEOSERVER_DATA_DIR && \
	chown tomcat7:tomcat7 $GEOSERVER_DATA_DIR

# Run the command as the geoserver user:
USER tomcat7

# Expose network ports:
EXPOSE 8080

CMD ["/usr/share/tomcat7/bin/catalina.sh", "run"]