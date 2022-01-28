#!/bin/sh

RESTORE_WORKING_DIR=$(mktemp -d)
RESTORE_FILE=$1

tar -xzf $1 -C $RESTORE_WORKING_DIR

for i in user hiera node; do
  /opt/puppetlabs/bin/pds-cli $i create -f $RESTORE_WORKING_DIR/$i.json 2>&1 >&/dev/null
done

rm -rf $RESTORE_WORKING_DIR