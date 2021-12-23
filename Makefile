NAME=pds-server
VERSION=0.1.0-dev

OS := $(strip $(shell uname))
RUBY_VERSION := $(strip $(shell cd app && /opt/puppetlabs/puppet/bin/ruby -e 'puts RUBY_VERSION.sub(/\d+$$/, "0")'))

pds-cli = golang/pds-cli/pds-cli
bundle = app/vendor/bundle/ruby/$(RUBY_VERSION)
pe-postgresql-devel = /opt/puppetlabs/server/apps/postgresql/11/include
go = /usr/bin/go
fpm = /opt/puppetlabs/puppet/bin/fpm

.PHONY: rpm clean

rpm: $(bundle) $(pds-cli) $(fpm)
	$(fpm) -s dir -t rpm -n $(NAME) -a x86_64 -v $(VERSION) \
		--before-install package/rpm/preinstall \
		--after-install package/rpm/postinstall \
		--before-remove package/rpm/preuninstall \
		--after-remove package/rpm/postuninstall \
		--config-files /etc/puppetlabs/pds-server/pds.yaml \
		--config-files /etc/puppetlabs/pds-server/pds-cli.yaml \
		--rpm-attr '0600,pds-server,pds-server:/etc/puppetlabs/pds-server/pds.yaml' \
		--rpm-attr '0640,pds-server,pe-puppet:/etc/puppetlabs/pds-server/pds-cli.yaml' \
		app/=/opt/puppetlabs/server/apps/pds-server \
		app/config/pds.yaml.example=/etc/puppetlabs/pds-server/pds.yaml \
		golang/pds-cli/pds-cli=/opt/puppetlabs/bin/pds-cli \
		golang/pds-cli/pds-cli.yaml.example=/etc/puppetlabs/pds-server/pds-cli.yaml \
		package/pds=/etc/puppetlabs/puppet/trusted-external-commands/pds \
		package/pds-ctl=/opt/puppetlabs/sbin/pds-ctl \
		package/pds-server.service=/usr/lib/systemd/system/pds-server.service

clean:
	rm -rf app/vendor/bundle
	rm -f app/config/pds.yaml
	rm -f golang/pds-cli/pds-cli
	rm -f golang/pds-cli/pds-cli.yaml
	rm -f pds-server*.rpm

$(pds-cli): $(wildcard golang/**/*.go) /usr/bin/go
	cd golang/pds-cli && go build

$(bundle): app/Gemfile app/Gemfile.lock
	cd app && PATH=$$PATH:/opt/puppetlabs/server/bin /opt/puppetlabs/puppet/bin/bundle install \
		|| touch app/Gemfile.lock

# Require various build dependencies be installed and handled automatically, IF
# the build is running on Linux
ifeq ($(OS), Linux)
$(bundle): $(pe-postgresql-devel)
$(pds-cli): $(go)
endif

$(pe-postgresql-devel):
	sudo yum install -y pe-postgresql11-devel

$(go):
	sudo yum install -y golang

$(fpm):
	sudo /opt/puppetlabs/puppet/bin/gem install --no-document fpm
