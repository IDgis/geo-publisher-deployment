# Publisher proxy deployment

## Environment variables

- ``PUBLISHER_GEOSERVER_DOMAIN``: the domain name to use in the Geoserver vhost. Can be equal to ``PUBLISHER_WEB_DOMAIN``. Default value: ``overijssel.geo-hosting.nl``.
- ``PUBLISHER_WEB_DOMAIN``: the domain name to use in the web vhost. Can be equal to ``PUBLISHER_GEOSERVER_DOMAIN``. Default value: ``overijssel.geo-hosting.nl``.

## Required/linked hosts/containers

Requires links to the following containers or hosts:

- ``web``: container or host containing the publisher web application. Must expose the HTTP interface on port 9000.
- ``geoserver``: container or host containing the publisher geoserver web application. Must expose the AJP interface on port 8009.

## Volumes

Volumes are required for logs and certificates:

- ``/etc/ssl/certs``: location where SSL certificates are stored.
- ``/etc/ssl/private``: location where the SSL private key is stored.
- ``/var/www/geo-publisher/metadata``: location where the service metadata is stored. Created as part of the geo-publisher-service container.

```
docker run --name geo-publisher-dv-proxy-ssl-certs -d -v /etc/ssl/certs geo-publisher-proxy:$VERSION true
docker run --name geo-publisher-dv-proxy-ssl-private -d -v /etc/ssl/private geo-publisher-proxy:$VERSION true
docker run --name geo-publisher-dv-proxy-logs -d -v /var/log/apache2 geo-publisher-proxy:$VERSION true
```

## Exposed ports

- ``80``: the HTTP port.
- ``443``: the HTTP+SSL port.

When starting the container, these ports should also be exposed on the host.

## Container deployment

```
docker run \ 
	--name geo-publisher-proxy \ 
	-h proxy \
	-d \
	--link geo-publisher-web:web \ 
	--link geo-publisher-geoserver:geoserver \ 
	--volumes-from geo-publisher-dv-proxy-ssl-certs \ 
	--volumes-from geo-publisher-dv-proxy-ssl-private \
	--volumes-from geo-publisher-dv-proxy-logs \
	--volumes-from geo-publisher-dv-service-metadata \
	--restart=always \
	-p 80:80 \
	-p 443:443 \
	-e PUBLISHER_GEOSERVER_DOMAIN=<domain> \
	-e PUBLISHER_WEB_DOMAIN=<domain> \
	geo-publisher-proxy:$VERSION 
```