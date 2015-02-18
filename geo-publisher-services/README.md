## Environment variables

- ``VERSION``: the version of Geo Publisher to deploy.
- ``PG_USER``: the database user. From the docker-postgis image.
- ``PG_PASSWORD``: the database password. From the docker-postgis image.
- ``PUBLISHER_DATA_SOURCE_ID``: ID of the default datasource. A datasource with this ID is added after creating or updating the database. Default value: ``my-provider-name``.
- ``PUBLISHER_DATA_SOURCE_NAME``: name of the default datasource. A datasource with this name is added after creating or updating the database. Default value: ``My Provider Name``.

## Copy certificates

```
docker run \ 
	--rm \
	--volumes-from geo-publisher-dv-service-sslconf \ 
	-v /path/to/local/certs:/opt/certs \
	geo-publisher-service:$VERSION \
	sh -c
		'cp /opt/certs/*.jks /etc/geo-publisher/ssl/'
```

## Setting up the database

The database requires two data-only volumes for data and logs, these are created first:

```
docker run --name geo-publisher-db-data -d -v /var/lib/postgresql geo-publisher-postgis:$VERSION true
docker run --name geo-publisher-db-log -d -v /var/log/postgresql geo-publisher-postgis:$VERSION true
```

The database is started and mounts the data volumes created previously:

```
docker run \ 
	--name geo-publisher-db \ 
	-d \ 
	--volumes-from geo-publisher-db-data \ 
	--volumes-from geo-publisher-db-log \
	--restart=always \
	-e PG_USER=$PG_USER \
	-e PG_PASSWORD=$PG_PASSWORD \
	-e PUBLISHER_DATA_SOURCE_ID=$PUBLISHER_DATA_SOURCE_ID \
	-e PUBLISHER_DATA_SOURCE_NAME=$PUBLISHER_DATA_SOURCE_NAME \ 
	geo-publisher-postgis:$VERSION
```