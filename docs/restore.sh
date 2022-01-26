#!/bin/sh

RESTORE_WORKING_DIR=$(mktemp -d)
RESTORE_FILE=$1

URI=$(grep baseuri /etc/puppetlabs/pds/pds-client.yaml | awk '{print $2}')
TOKEN=$(grep token /etc/puppetlabs/pds/pds-client.yaml | awk '{print $2}')
CA=$(grep ca-file /etc/puppetlabs/pds/pds-client.yaml | awk '{print $2}')

tar -xzf $1 -C $RESTORE_WORKING_DIR

for i in users hiera-data nodes; do
  curl -s -k --cacert $CA -X POST $URI/$i -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" --data-binary @$RESTORE_WORKING_DIR/$i.json
done

rm -rf $RESTORE_WORKING_DIR