NAME=pds-service
VERSION=0.1.0-dev

pds-cli = golang/pds-cli/pds-cli
bundle = app/vendor/bundle/ruby/$(shell cd app && /opt/puppetlabs/puppet/bin/ruby -e 'puts RUBY_VERSION.sub(/\d+$$/, "0")')
pe-postgresql-devel = /opt/puppetlabs/server/apps/postgresql/11/include

.PHONY: rpm clean

rpm: $(bundle) $(pds-cli)
	fpm -s dir -t rpm -n $(NAME) -a x86_64 -v $(VERSION) \
		app/=/opt/puppetlabs/server/apps/pds-service \
		app/config/pds.yaml.example=/etc/puppetlabs/pds-service/pds.yaml.example \
		golang/pds-cli/pds-cli=/opt/puppetlabs/bin/pds-cli \
		golang/pds-cli/pds-cli.yaml.example=/etc/puppetlabs/pds-service/pds-cli.yaml.example \
		package/pds=/etc/puppetlabs/puppet/trusted-external-commands/pds \
		package/pdsctl=/opt/puppetlabs/sbin/pdsctl

clean:
	rm -rf app/vendor/bundle
	rm -f app/config/pds.yaml
	rm -f golang/pds-cli/pds-cli
	rm -f golang/pds-cli/pds-cli.yaml
	rm -f pds-service*.rpm

$(pds-cli): $(wildcard golang/**/*.go)
	cd golang/pds-cli && go build

$(bundle): app/Gemfile.lock $(pe-postgresql-devel)
	cd app && PATH=$$PATH:/opt/puppetlabs/server/bin /opt/puppetlabs/puppet/bin/bundle install \
		|| touch app/Gemfile.lock

$(pe-postgresql-devel):
	sudo yum install pe-postgresql-devel
