#!/bin/sh

BACKUP_WORKING_DIR=$(mktemp -d)
BACKUP_DEST=$1
BACKUP_TIME=$(date -Iseconds)

URI=$(grep baseuri /etc/puppetlabs/pds/pds-client.yaml | awk '{print $2}')
TOKEN=$(grep token /etc/puppetlabs/pds/pds-client.yaml | awk '{print $2}')
CA=$(grep ca-file /etc/puppetlabs/pds/pds-client.yaml | awk '{print $2}')

for i in users hiera-data nodes; do
  curl -s -k --cacert $CA -X GET $URI/$i -H "Accept: application/json" -H "Authorization: Bearer $TOKEN" | jq 'map(select(.username != "admin")) | {"resources": . }' > $BACKUP_WORKING_DIR/$i.json
done

tar -czf $BACKUP_DEST/pds-backup-$BACKUP_TIME.tar.gz -C $BACKUP_WORKING_DIR .

rm -rf $BACKUP_WORKING_DIR