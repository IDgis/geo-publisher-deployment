# Publisher web deployment

## Environment variables

- ``PUBLISHER_WEB_SECRET``: the Play "secret" to use. This property should always be overridden with a non-default value for public deployments.
- ``PUBLISHER_WEB_AKKA_HOST``: the hostname to use for Akka remoting. This is the host on which the actorsystem in this container is accessible to other containers. The hostname of the containerer running publisher-web should also be set to this value. Default value: ``web``.
- ``PUBLISHER_WEB_AKKA_PORT``: the port to use for Akka remoting. This is the port on which the actorsystem in this container is accessible to other containers. Default value: ``2552``.
- ``PUBLISHER_WEB_DATABASE_REF``: actor reference used by publisher-web to access the backend. Default value: ``akka.tcp://service@service:2552/user/app/admin``.
- ``PUBLISHER_WEB_ADMIN_USERNAME``: username to use when logging in to the admin interface. Default value: ``admin@idgis.nl``. Use a non-default value for public deployments.
- ``PUBLISHER_WEB_ADMIN_PASSWORD``: password to use when logging in to the admin interface. Use a non-default value for public deployments.
- ``PUBLISHER_WEB_ADMIN_DASHBOARD_ERROR_COUNT``: the number of errors to display on the dashboard page. Default value: ``5``.
- ``PUBLISHER_WEB_ADMIN_DASHBOARD_NOTIFICATION_COUNT``: the number of notifications to display on the dashboard page. Default value: ``5``.
- ``PUBLISHER_WEB_JAVA_OPTS``: additional java options (e.g. ``-D...``) to pass to the JVM running the Play application. Can be used to override settings in the Play configuration that are not covered by the preceeding environment variables.

## Exposed ports

Containers using this image expose the following ports:

- ``9000``: the HTTP-port on which the application is accessible.

## Container deployment

The publisher-web container needs a hostname and a reference to the container running the backend.

Example deployment:
```
docker run \
  --name geo-publisher-web \
  --restart=always \
  -d \
  --link <backend-container-name>:service \
  -h web \
  -e PUBLISHER_WEB_ADMIN_USERNAME=<username> \
  -e PUBLISHER_WEB_ADMIN_PASSWORD=<password> \
  geo-publisher-web:<version>
```
