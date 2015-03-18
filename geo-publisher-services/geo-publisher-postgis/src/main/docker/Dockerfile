FROM docker-postgis:0.1.0

# Environment variables:
ENV PG_DATABASE="publisher"
ENV PG_VERSION_SCHEMA="publisher"
ENV PG_VERSION_TABLE="version"
ENV PUBLISHER_DATA_SOURCE_ID="my-provider-name"
ENV PUBLISHER_DATA_SOURCE_NAME="My Provider Name"

# Copy SQL scripts:
COPY sql/*.sql /opt/sql/

# Copy update scripts:
COPY update-db.d/* /opt/update-db.d/

USER root
RUN chmod +x /opt/update-db.d/*
USER postgres