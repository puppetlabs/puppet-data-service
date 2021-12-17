NAME=pds-service
VERSION=0.1.0-dev

pds-cli = golang/pds-cli/pds-cli
bundle = app/vendor/bundle/ruby/$(shell cd app && /opt/puppetlabs/puppet/bin/ruby -e 'puts RUBY_VERSION.sub(/\d+$$/, "0")')

.PHONY: package clean

package: $(bundle) $(pds-cli)
	fpm -s dir -t rpm -n $(NAME) -a x86_64 -v $(VERSION) \
		app=/opt/puppetlabs/server/apps/pds-service \
		app/config/pds.yaml.example=/etc/puppetlabs/pds-service/pds.yaml.example \
		golang/pds-cli/pds-cli=/opt/puppetlabs/bin/pds-cli \
		golang/pds-cli/pds-cli.yaml.example=/etc/puppetlabs/pds-service/pds-cli.yaml.example \
		package/pds=/opt/puppetlabs/puppet/trusted-external-commands/pds \
		package/pds-rake=/opt/puppetlabs/sbin/pds-rake

clean:
	rm -rf app/vendor/bundle
	rm app/config/pds.yaml
	rm golang/pds-cli/pds-cli
	rm golang/pds-cli/pds-cli.yaml
	rm pds-service*.rpm

$(pds-cli): $(wildcard golang/**/*.go)
	cd golang/pds-cli && go build

$(bundle): app/Gemfile.lock
	cd app && /opt/puppetlabs/puppet/bin/bundle install
