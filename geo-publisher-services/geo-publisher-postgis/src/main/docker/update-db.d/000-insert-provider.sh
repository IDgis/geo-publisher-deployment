#!/bin/bash

DSID=$(psql -d $PG_DATABASE -At -c "select identification from publisher.data_source where identification = '$PUBLISHER_DATA_SOURCE_ID';")
if [[ "${DSID}" != "$PUBLISHER_DATA_SOURCE_ID" ]]; then
	echo "Inserting default provider $PUBLISHER_DATA_SOURCE_NAME ($PUBLISHER_DATA_SOURCE_ID) ..."
	psql -d $PG_DATABASE -At -c "insert into publisher.data_source(identification, name)values('$PUBLISHER_DATA_SOURCE_ID', '$PUBLISHER_DATA_SOURCE_NAME');"
fi