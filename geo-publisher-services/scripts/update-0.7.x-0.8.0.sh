#!/bin/bash

set -e

# Test parameters
if [[ $# < 1 ]]; then
	echo "Usage: $0 [instance name]"
	exit 1
fi

INSTANCE=$1

docker exec gp-$INSTANCE-db psql -c "update publisher.data_source set identification = 'overijssel-gisbasip', name = 'Overijssel vectordata' where identification = 'overijssel';
