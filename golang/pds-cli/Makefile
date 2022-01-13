CLI=./pds-cli --baseuri http://127.0.0.1:4011 --token admin_token

pds-cli: generate build

build:
	go build

generate:
	go generate ../pkg/pds-go-client/doc.go

prism:
	@npm list -g --depth=0 prism > /dev/null || echo "No prism found. To install prism: sudo npm install -g prism"

proxy: prism
	prism mock ../../docs/api.yml --errors -d -p 4011 &
	prism proxy  ../../docs/api.yml http://127.0.0.1:4011 &

app-proxy: prism
	prism proxy ../../docs/api.yml http://127.0.0.1:8160/v1 --errors -p 4011 &

killproxy:
	killall node

test-hiera:
	@echo "*** hiera ***"
	$(CLI) hiera list
	$(CLI) hiera list -l common
	$(CLI) hiera get common pds::color
	$(CLI) hiera upsert somelevel somekey -v '"somevalue"'
	$(CLI) hiera delete somelevel somekey
	$(CLI) hiera delete level key   || true  # it's ok if not exist
	$(CLI) hiera delete level1 key1 || true  # it's ok if not exist
	$(CLI) hiera delete level1 key2 || true  # it's ok if not exist
	$(CLI) hiera delete level2 key1 || true  # it's ok if not exist
	$(CLI) hiera create -f fixtures/hieradata.json
	$(CLI) hiera delete level1 key1
	$(CLI) hiera delete level1 key2
	$(CLI) hiera delete level2 key1

test-user:
	@echo "*** user ***"
	$(CLI) user list
	$(CLI) user get alice
	$(CLI) user upsert someuser -e me@me.com -r operator
	$(CLI) user create -f fixtures/users.json
	$(CLI) user delete someuser
	$(CLI) user delete john
	$(CLI) user delete paul

test-node:
	@echo "*** node ***"
	$(CLI) node list
	$(CLI) node get ip-100.acme.com
	$(CLI) node upsert somenode 
	$(CLI) node create -f fixtures/nodes.json
	$(CLI) node delete somenode
	$(CLI) node delete node1
	$(CLI) node delete node2
	$(CLI) node delete node3
	$(CLI) node delete node4

test: pds-cli test-hiera test-user test-node

doc: pds-cli
	$(CLI) doc -d doc 
