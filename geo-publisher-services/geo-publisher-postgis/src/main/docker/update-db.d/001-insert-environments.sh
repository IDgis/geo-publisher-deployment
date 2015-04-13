#!/bin/bash

set -e

function create_environment() {
	ENVIRONMENT_IDENTIFICATION="$1"
	ENVIRONMENT_NAME="$2"
	ENVIRONMENT_CONFIDENTIAL="$3"
	
	ENVID=$(psql -d $PG_DATABASE -At -c "select identification from publisher.environment where identification = '$ENVIRONMENT_IDENTIFICATION';")
	if [[ "${ENVID}" != "$ENVIRONMENT_IDENTIFICATION" ]]; then
		echo "Inserting environment $ENVIRONMENT_NAME ($ENVIRONMENT_IDENTIFICATION, $ENVIRONMENT_CONFIDENTIAL) ..."
		psql -d $PG_DATABASE -At -c "insert into publisher.environment(identification, name, confidential)values('$ENVIRONMENT_IDENTIFICATION', '$ENVIRONMENT_NAME', $ENVIRONMENT_CONFIDENTIAL);"
	fi
}

create_environment "geoserver-public" "$PUBLISHER_PUBLIC_ENVIRONMENT_NAME" false
create_environment "geoserver-secure" "$PUBLISHER_SECURE_ENVIRONMENT_NAME" true
create_environment "geoserver-guaranteed" "$PUBLISHER_GUARANTEED_ENVIRONMENT_NAME" false