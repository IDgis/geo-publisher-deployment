# Publisher database deployment

## Environment variables

- ``PG_USER``: the database user. From the docker-postgis image.
- ``PG_PASSWORD``: the database password. From the docker-postgis image.
- ``PUBLISHER_DATA_SOURCE_ID``: ID of the default datasource. A datasource with this ID is added after creating or updating the database. Default value: ``my-provider-name``.
- ``PUBLISHER_DATA_SOURCE_NAME``: name of the default datasource. A datasource with this name is added after creating or updating the database. Default value: ``My Provider Name``.

## Volumes

- ``/var/lib/postgresql``: database data directory.
- ``/var/log/postgresql``: database log directory.

## Exposed ports

- ``5432``: the PostgreSQL port.

## Container deployment

The database container requires a database username/password, configuration for the default data source and two data volumes.
The hostname must be set to ``db``

```
docker run \
  --name geo-publisher-db \
  --restart=always \
  -d \
  -h db \
  --volumes-from <dblog-container> \
  --volumes-from <dbdata-container> \
  -e PG_USER=<username> \
  -e PG_PASSWORD=<password> \
  -e PUBLISHER_DATA_SOURCE_ID=<data source id> \
  -e PUBLISHER_DATA_SOURCE_NAME=<data source name> \
  geo-publisher-postgis:<version>
```