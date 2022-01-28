#!/bin/bash


# Trap exits, and set exit on error
function cleanup() { jobs -p | xargs kill; }
trap cleanup ERR
set -e

# Make sure we're starting in the expected directory
cd "$(dirname "$0")"
basedir='..'

if ! command -v prism >/dev/null; then
  echo '`prism` must be available in PATH to run smoke test.'
  exit 1
fi

if [[ ! -e "${basedir}/golang/pds-cli/pds-cli" ]]; then
  pushd "${basedir}/golang/pds-cli"
    go build
  popd
fi

if [[ ! -e "${basedir}/app/config/pds-server.yaml" ]]; then
	cat <<-EOF
		There must exist an app/config/pds-server.yaml file with a working
		configuration, for this smoke test to complete. The suggested configuration
		for quick tests is to use the mock adapter.
		
		  ---
		  authenticate: false
		  database:
		    adapter: mock
		
	EOF
  exit 1
fi

# Start required processes
pushd "${basedir}/app"
  bundle exec puma -p 8161 &
popd

prism proxy "${basedir}/docs/api.yml" http://127.0.0.1:8161/v1 --errors -p 8160 &

# Wait to give puma time to start up
sleep 2

# Path to pds-cli executable
cli='../golang/pds-cli/pds-cli --config fixtures/pds-client-prism.yaml'

set -x

# Hiera tests
$cli hiera list
$cli hiera list -l common
$cli hiera get common pds::color
$cli hiera upsert somelevel somekey -v '"somevalue"'
$cli hiera delete somelevel somekey
$cli hiera create -f fixtures/hieradata.json
$cli hiera delete level1 key1
$cli hiera delete level1 key2
$cli hiera delete level2 key1

# User tests
$cli user list
$cli user get alice
$cli user upsert someuser -e me@me.com -r operator
$cli user create -f fixtures/users.json
$cli user delete someuser
$cli user delete john
$cli user delete paul

# Node tests
$cli node list
$cli node get ip-100.acme.com
$cli node upsert somenode 
$cli node create -f fixtures/nodes.json
$cli node delete somenode
$cli node delete node1
$cli node delete node2
$cli node delete node3
$cli node delete node4

set +x
set +e
echo
echo 'It worked! Smoke tests ran successfully to completion.'
echo
cleanup
