#!/bin/sh

BACKUP_WORKING_DIR=$(mktemp -d)
BACKUP_DEST=$1
BACKUP_TIME=$(date -Iseconds)

for i in users hiera-data nodes; do
  curl -s -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' http://localhost:8080/v1/$i > $BACKUP_WORKING_DIR/$i.json
done

tar -czf $BACKUP_DEST/pds-backup-$BACKUP_TIME.tar.gz -C $BACKUP_WORKING_DIR .

rm -rf $BACKUP_WORKING_DIR
