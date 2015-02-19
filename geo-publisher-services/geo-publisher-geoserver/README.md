# Publisher Geoserver deployment

## Environment variables

- ``PUBLISHER_GEOSERVER_USER``: username used to protect the Geoserver admin and REST interface. Default value: ``admin``.
- ``ENV PUBLISHER_GEOSERVER_PASSWORD``: passwordt used to protect the Geoserver andmin and REST interface. A non-default value should be set.
- ``PUBLISHER_GEOSERVER_JAVA_OPTS``: optional additional parameters passed to the JVM running Geoserver (e.g. ``-D...``).

## Volumes

The Geoserver data directory should be mounted from a volume:

- ``/var/lib/geo-publisher/geoserver``: geoserver data directory.

```
docker run \ 
	--name geo-publisher-dv-geoserver-data \ 
	-d \
	-v /var/lib/geo-publisher/geoserver \ 
	geo-publisher-geoserver:$VERSION \
	true
```

## Exposed ports

- ``8080``: the HTTP port. Geoserver is available on the path ``/geoserver``.
- ``8009``: the AJP port. Geoserver is available on the path ``/geoserver``.

## Container deployment

```
docker run \
	--name geo-publisher-geoserver \ 
	-h geoserver \
	-d \
	--volumes-from geo-publisher-dv-geoserver-data \ 
	--restart=always \
	-e PUBLISHER_GEOSERVER_USER=<username> \
	-e PUBLISHER_GEOSERVER_PASSWORD=<password> \ 
	geo-publisher-geoserver:$VERSION
```