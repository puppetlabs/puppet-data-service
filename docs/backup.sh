#!/bin/sh

BACKUP_WORKING_DIR=$(mktemp -d)
BACKUP_DEST=$1
BACKUP_TIME=$(date -Iseconds)

for i in user hiera node; do
  /opt/puppetlabs/bin/pds-cli $i list 2>/dev/null| jq 'map(select(.username != "admin")) | {"resources": . }' > $BACKUP_WORKING_DIR/$i.json
done

tar -czf $BACKUP_DEST/pds-backup-$BACKUP_TIME.tar.gz -C $BACKUP_WORKING_DIR .

rm -rf $BACKUP_WORKING_DIR