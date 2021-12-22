NAME=pds-server
VERSION=0.1.0-dev

OS := $(strip $(shell uname))
RUBY_VERSION := $(strip $(shell cd app && /opt/puppetlabs/puppet/bin/ruby -e 'puts RUBY_VERSION.sub(/\d+$$/, "0")'))

pds-cli = golang/pds-cli/pds-cli
bundle = app/vendor/bundle/ruby/$(RUBY_VERSION)
pe-postgresql-devel = /opt/puppetlabs/server/apps/postgresql/11/include

.PHONY: rpm clean

rpm: $(bundle) $(pds-cli)
	fpm -s dir -t rpm -n $(NAME) -a x86_64 -v $(VERSION) \
		--before-install package/rpm/preinstall \
		--after-install package/rpm/postinstall \
		--after-remove package/rpm/postuninstall \
		app/=/opt/puppetlabs/server/apps/pds-server \
		app/config/pds.yaml.example=/etc/puppetlabs/pds-server/pds.yaml.example \
		golang/pds-cli/pds-cli=/opt/puppetlabs/bin/pds-cli \
		golang/pds-cli/pds-cli.yaml.example=/etc/puppetlabs/pds-server/pds-cli.yaml.example \
		package/pds=/etc/puppetlabs/puppet/trusted-external-commands/pds \
		package/pds-ctl=/opt/puppetlabs/sbin/pds-ctl \
		package/pds-server.service=/usr/lib/systemd/system/pds-server.service

clean:
	rm -rf app/vendor/bundle
	rm -f app/config/pds.yaml
	rm -f golang/pds-cli/pds-cli
	rm -f golang/pds-cli/pds-cli.yaml
	rm -f pds-server*.rpm

$(pds-cli): $(wildcard golang/**/*.go)
	cd golang/pds-cli && go build

$(bundle): app/Gemfile.lock
	cd app && PATH=$$PATH:/opt/puppetlabs/server/bin /opt/puppetlabs/puppet/bin/bundle install \
		|| touch app/Gemfile.lock

# Require that the pe-postgresql11-devel package be installed to build the
# bundle IF the build is running on Linux
ifeq ($(OS), Linux)
$(bundle): $(pe-postgresql-devel)
endif

$(pe-postgresql-devel):
	sudo yum install pe-postgresql-devel
