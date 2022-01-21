#!/bin/sh

RESTORE_WORKING_DIR=$(mktemp -d)
RESTORE_FILE=$1

tar -xzf $1 -C $RESTORE_WORKING_DIR

for i in users hiera-data nodes; do
  curl -X POST -H 'Content-Type: application/json' -H 'Accept: application/json' --data-binary @$RESTORE_WORKING_DIR/$i.json http://localhost:8080/v1/$i
done

rm -rf $RESTORE_WORKING_DIR
