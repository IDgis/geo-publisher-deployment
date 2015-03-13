# Geo publisher deployment

Geo publisher can be deployed by creating a container for each Docker image 
by following the individual container's instructions. Containers should be 
started in the following order:

1. ``geo-publisher-postgis``
2. ``geo-publisher-geoserver``
3. ``geo-publisher-service``
4. ``geo-publisher-web``
5. ``geo-publisher-proxy``

The process of starting the containers is automated using the script 
``scripts/deploy.sh``. Use this script as follows on the Docker host:

```
deploy.sh 0.0.1-SNAPSHOT settings.conf 
```

The first argument indicates the version to deploy. Docker images for this 
version must have previously been created or checked out on the host. The
second argument points to a file containing the settings to use when deploying.
Possible settings and their default values are described in the following 
section.

Not that setting usernames and passwords in the settings file only has effect
when the application is first deployed since these values are typically stored
in data containers. These values cannot be changed between updates.

## Environment variables

- ``PG_USER``: the database user. From the docker-postgis image.
- ``PG_PASSWORD``: the database password. From the docker-postgis image.
- ``PUBLISHER_DATA_SOURCE_ID``: ID of the default datasource. A datasource with this ID is added after creating or updating the database. Default value: ``my-provider-name``.
- ``PUBLISHER_DATA_SOURCE_NAME``: name of the default datasource. A datasource with this name is added after creating or updating the database. Default value: ``My Provider Name``.
- ``PUBLISHER_GEOSERVER_USER``: username used to protect the Geoserver admin and REST interface. Default value: ``admin``.
- ``ENV PUBLISHER_GEOSERVER_PASSWORD``: passwordt used to protect the Geoserver andmin and REST interface. A non-default value should be set.
- ``PUBLISHER_GEOSERVER_JAVA_OPTS``: optional additional parameters passed to the JVM running Geoserver (e.g. ``-D...``).
- ``PUBLISHER_SERVICE_HOSTNAME``: hostname of the publisher service container. Default value: ``service``.
- ``PUBLISHER_SERVICE_AKKA_LOGLEVEL``: loglevel of the Akka actorsystem. Default value: ``DEBUG``.
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
- ``PUBLISHER_WEB_SECRET``: the Play "secret" to use. This property should always be overridden with a non-default value for public deployments.
- ``PUBLISHER_WEB_ADMIN_USERNAME``: username to use when logging in to the admin interface. Default value: ``admin@idgis.nl``. Use a non-default value for public deployments.
- ``PUBLISHER_WEB_ADMIN_PASSWORD``: password to use when logging in to the admin interface. Use a non-default value for public deployments.
- ``PUBLISHER_WEB_ADMIN_DASHBOARD_ERROR_COUNT``: the number of errors to display on the dashboard page. Default value: ``5``.
- ``PUBLISHER_WEB_ADMIN_DASHBOARD_NOTIFICATION_COUNT``: the number of notifications to display on the dashboard page. Default value: ``5``.
- ``PUBLISHER_WEB_JAVA_OPTS``: additional java options (e.g. ``-D...``) to pass to the JVM running the Play application. Can be used to override settings in the Play configuration that are not covered by the preceeding environment variables.

## Copy certificates

The publisher service requires two certificate files named ``private.jks`` and ``trusted.jks``.
Due to the high sensitivity of these files, they need to be copied into the appropriate data volume
manually using the following command:

```
docker run \ 
	--rm \
	--volumes-from geo-publisher-dv-service-sslconf \ 
	-v /path/to/local/certs:/opt/certs \
	geo-publisher-service:$VERSION \
	sh -c
		'cp /opt/certs/*.jks /etc/geo-publisher/ssl/'
```

Copy certificates for apache:

```
docker run \
	--rm \
	--volumes-from geo-publisher-dv-proxy-ssl-certs \
	-v /path/to/certificates:/opt/ssl/certs \
	geo-publisher-proxy:$VERSION \
	sh -c \
		'cp /opt/ssl/certs/cert.pem /etc/ssl/certs/'
docker run \
	--rm \
	--volumes-from geo-publisher-dv-proxy-ssl-private \
	-v /path/to/certificates:/opt/ssl/certs \
	geo-publisher-proxy:$VERSION \
	sh -c \
		'cp /opt/ssl/certs/private.key /etc/ssl/private/'
```

## (Optional) install additional Geoserver fonts

Assuming you have a directory on the host containing font files, the following command copies them into the Geoserver styles directory:

```
docker run \
	--rm \
	--volumes-from geo-publisher-dv-geoserver-data \
	-v /path/to/fonts:/opt/fonts \
	geo-publisher-geoserver:$VERSION \
	sh -c \
		'cp /opt/fonts/* /var/lib/geo-publisher/geoserver/styles/'
```

After copying new font files, the geoserver container should be restarted

## Quick installation in a Vagrant VM

Geo publisher can easily be deployed in a VM created using Vagrant using the
following steps:

1. Run ``vagrant up`` in the root of the geo-publisher-services project.
2. Create the Docker images by running ``mvn package``. Port mappings are
   configured correctly for this to work out of the box.
3. Log in to the Vagrant VM using SSH on port ``2222`` (username and password
   are both ``vagrant`` by default).
4. Run the following command: 
   ``sudo /vagrant/scripts/deploy.sh /vagrant/scripts/ontw.settings``.
5. Follow the instructions under "Copy certificates". 
