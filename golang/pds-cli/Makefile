CLI=./pds-cli --baseuri http://localhost:4010 --token admin_token

pds-cli: generate build

build:
	go build

generate:
	go generate ../pkg/pds-go-client/doc.go

prism:
	@npm list -g --depth=0 prism > /dev/null || echo "No prism found. To install prism: sudo npm install -g prism"

proxy: prism
	prism mock ../../docs/api.yml --errors -d -p 4011 &
	prism proxy  ../../docs/api.yml http://localhost:4011 &

app-proxy: prism
	prism proxy  ../../docs/api.yml http://localhost:8080/v1 &

killproxy:
	killall node

test-hiera:
	@echo "*** hiera ***"
	$(CLI) hiera list
	$(CLI) hiera list -l common
	$(CLI) hiera get -l common -k pds::color
	$(CLI) hiera upsert -l somelevel -k somekey -v '"somevalue"'
	$(CLI) hiera delete -l somelevel -k somekey
	$(CLI) hiera delete -l level -k key   || true  # it's ok if not exist
	$(CLI) hiera delete -l level1 -k key1 || true  # it's ok if not exist
	$(CLI) hiera delete -l level1 -k key2 || true  # it's ok if not exist
	$(CLI) hiera delete -l level2 -k key1 || true  # it's ok if not exist
	$(CLI) hiera create -f fixtures/hieradata.json
	$(CLI) hiera delete -l level1 -k key1
	$(CLI) hiera delete -l level1 -k key2
	$(CLI) hiera delete -l level2 -k key1

test-user:
	@echo "*** user ***"
	$(CLI) user list
	$(CLI) user get -n alice
	$(CLI) user upsert -n someuser -e me@me.com -r operator
	$(CLI) user create -f fixtures/users.json
	$(CLI) user delete -n someuser

test-node:
	@echo "*** node ***"
	$(CLI) node list
	$(CLI) node get -n ip-100.acme.com
	$(CLI) node upsert -n somenode 
	$(CLI) node create -f fixtures/nodes.json
	$(CLI) node delete -n somenode

test: pds-cli test-hiera test-user test-node


