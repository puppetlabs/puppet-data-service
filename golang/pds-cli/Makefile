CLI=./pds-cli --baseuri http://localhost:4010

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

killproxy:
	killall node

test: pds-cli
	@echo "*** hiera ***"
	$(CLI) hiera list
	$(CLI) hiera list -l somelevel
	$(CLI) hiera get -l somelevel -k somekey
	$(CLI) hiera upsert -l somelevel -k somekey -v '"somevalue"'
	$(CLI) hiera create -f fixtures/hieradata.json
	$(CLI) hiera delete -l somelevel -k somekey

	@echo "*** user ***"
	$(CLI) user list
	$(CLI) user get -n someuser
	$(CLI) user upsert -n someuser -e me@me.com -r operator
	$(CLI) user create -f fixtures/users.json
	$(CLI) user delete -n someuser

	@echo "*** node ***"
	$(CLI) node list
	$(CLI) node get -n somenode
	$(CLI) node upsert -n somenode 
	$(CLI) node create -f fixtures/nodes.json
	$(CLI) node delete -n somenode