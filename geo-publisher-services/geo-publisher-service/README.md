# Publisher web deployment

## Environment variables

- ``PUBLISHER_SERVICE_HOSTNAME``: hostname of the publisher service container. Default value: ``service``.
- ``PUBLISHER_SERVICE_AKKA_LOGLEVEL``: loglevel of the Akka actorsystem. Default value: ``DEBUG``.
- ``PUBLISHER_DATABASE_USER``: name of the database user. Default value: ``publisher``.
- ``PUBLISHER_DATABASE_PASSWORD``: password of the database user. Should be set to a non-default value.
- ``PUBLISHER_GEOSERVER_USER``: username to access the REST interface of the Geoserver instance. Default value: ``admin``.
- ``PUBLISHER_GEOSERVER_PASSWORD``: password used to access the REST interface of the Geoserver instance. Should be set to a non-default value.
- ``PUBLISHER_GEOSERVER_SCHEMA``: the geoserver schema. Default value: ``staging_data``.
- ``PUBLISHER_SERVICE_HARVESTER_SSL_PRIVATE_PASSWORD``: password used to access the private keystore for the harvester. Should be set to a non-default value.
- ``PUBLISHER_SERVICE_HARVESTER_SSL_TRUSTED_PASSWORD``: password used to access the trusted keystore for the harvester. Should be set to a non-default value.
- ``PUBLISHER_SERVICE_MONITOR_SHOWTREES``: Default value: ``true``.
- ``PUBLISHER_SERVICE_JAVA_OPTS``: additional options passed to the JVM running the publisher service (e.g. ``-D...``) not covered by any of the environment variables described above.
- ``PUBLISHER_SERVICE_METADATA_OPERATESON``: the operates on property in generated metadata. Default value: ``https://overijssel.geo-hosting.nl/metadata/dataset/``.
- ``PUBLISHER_SERVICE_METADATA_WMS``: the online resource for WMS in generated metadata. Default value: ``https://overijssel.geo-hosting.nl/geoserver/wms?``.
- ``PUBLISHER_SERVICE_METADATA_WFS``: the online resource for WFS in generated metadata. Default value: ``https://overijssel.geo-hosting.nl/geoserver/wfs?``.

## Required hosts/containers

The following hosts must be present as references to other containers:

- ``db``: the database container.
- ``geoserver``: the geoserver container.

## Volumes

The following directories should be available as a data-volume:

- ``/etc/geo-publisher/ssl``: directory containing the SSL key stores ``private.jks`` and ``trusted.jks``.

## Exposed ports

- ``2552``: the akka port.
- ``4242``: the harvester port.

## Container deployment

The publisher service container needs a hostname (equal to ``PUBLISHER_SERVICE_HOSTNAME``) and references to the database and geoserver containers in the form of additional links.

```
docker run \
  --name geo-publisher-service \
  --restart=always \
  -d \
  --link <database-container-name>:db \
  --link <geoserver-container-name>:geoserver \ 
  -h service \
  -e PUBLISHER_DATABASE_USER=<username> \
  -e PUBLISHER_DATABASE_PASSWORD=<password> \
  -e PUBLISHER_GEOSERVER_USER=<username> \
  -e PUBLISHER_GEOSERVER_PASSWORD=<password> \
  -e PUBLISHER_SERVICE_HARVESTER_SSL_PRIVATE_PASSWORD=<password> \
  -e PUBLISHER_SERVICE_HARVESTER_SSL_TRUSTED_PASSWORD=<password> \
  geo-publisher-service:<version>
``` 