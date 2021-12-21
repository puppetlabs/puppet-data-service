pds-cli: generate build

build:
	go build

generate:
	go generate ../pkg/pds-go-client/doc.go

proxy:
	prism mock ../../docs/api.yml --errors -d -p 4011 &
	prism proxy  ../../docs/api.yml http://localhost:4011 &

killprism:
	killall node

test: pds-cli
	echo "*** hiera ***"
	./pds-cli hiera list
	./pds-cli hiera list -l somelevel
	./pds-cli hiera get -l somelevel -k somekey
	./pds-cli hiera upsert -l somelevel -k somekey -v somevalue
	./pds-cli hiera create -f fixtures/hiera.json
	./pds-cli hiera delete -l somelevel -k somekey

	echo "*** user ***"
	./pds-cli user list
	./pds-cli user get -n someuser
	./pds-cli user upsert -n someuser -e me@me.com -r operator
	./pds-cli user create -f fixtures/users.json
	./pds-cli user delete -n someuser

	echo "*** node ***"
	./pds-cli node list
	./pds-cli node get -n somenode
	./pds-cli node upsert -n somenode 
	./pds-cli node create -f fixtures/nodes.json
	./pds-cli node delete -n somenode
