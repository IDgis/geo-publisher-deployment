#!/bin/bash

set -e

function create_provider() {
	DATA_SOURCE_ID="$1"
	DATA_SOURCE_NAME="$2"	

	DSID=$(psql -d $PG_DATABASE -At -c "select identification from publisher.data_source where identification = '$DATA_SOURCE_ID';")
	if [[ "${DSID}" != "$DATA_SOURCE_ID" ]]; then
		echo "Inserting default provider $DATA_SOURCE_NAME ($DATA_SOURCE_ID) ..."
		psql -d $PG_DATABASE -At -c "insert into publisher.data_source(identification, name)values('$DATA_SOURCE_ID', '$DATA_SOURCE_NAME');"
	fi
}

create_provider "$PUBLISHER_DATA_SOURCE_ID" "$PUBLISHER_DATA_SOURCE_NAME"
create_provider "$PUBLISHER_RASTER_DATA_SOURCE_ID" "$PUBLISHER_RASTER_DATA_SOURCE_NAME"
