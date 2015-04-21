FROM docker-postgis:1.0.0

# Environment variables:
ENV PG_DATABASE="publisher"
ENV PG_VERSION_SCHEMA="publisher"
ENV PG_VERSION_TABLE="version"
ENV PUBLISHER_DATA_SOURCE_ID="vector"
ENV PUBLISHER_DATA_SOURCE_NAME="My Vector Provider Name"
ENV PUBLISHER_RASTER_DATA_SOURCE_ID="raster"
ENV PUBLISHER_RASTER_DATA_SOURCE_NAME="My Raster Provider Name"
ENV PUBLISHER_PUBLIC_ENVIRONMENT_NAME="Publieke services"
ENV PUBLISHER_SECURE_ENVIRONMENT_NAME="Beveiligde services"
ENV PUBLISHER_GUARANTEED_ENVIRONMENT_NAME="Gegarandeerde services"

# Copy SQL scripts:
COPY sql/*.sql /opt/sql/

# Copy update scripts:
COPY update-db.d/* /opt/update-db.d/

USER root
RUN chmod +x /opt/update-db.d/*
USER postgres