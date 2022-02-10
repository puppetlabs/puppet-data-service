NAME=pds-server
VERSION=0.1.0

OS := $(strip $(shell uname))
RUBY_VERSION := $(strip $(shell cd app && /opt/puppetlabs/puppet/bin/ruby -e 'puts RUBY_VERSION.sub(/\d+$$/, "0")'))

pds-cli = golang/pds-cli/pds-cli
bundle = app/vendor/bundle/ruby/$(RUBY_VERSION)
pe-postgresql-devel = /opt/puppetlabs/server/apps/postgresql/11/include
go = /usr/bin/go
fpm = /opt/puppetlabs/puppet/bin/fpm
erb = /opt/puppetlabs/puppet/bin/erb
gem = /opt/puppetlabs/puppet/bin/gem
bundler = /opt/puppetlabs/puppet/bin/bundle

.PHONY: rpm clean

rpm: $(bundle) $(pds-cli) $(fpm)
	# We don't want a symlink in the RPM, we want a regular file
	cd app && rm openapi.yaml && cp ../docs/api.yml openapi.yaml
	# generate the service unit file with the correct puma and ruby versions
	cd app && $(erb) puma_version=$$($(bundler) show 2>/dev/null|grep puma|grep -oP "\(\K[^\)]+") \
		ruby_version=$(RUBY_VERSION) < ../package/pds-server.service.erb > ../package/pds-server.service
	# Build the package
	$(fpm) -s dir -t rpm -n $(NAME) -a x86_64 -v $(VERSION) \
		-p $(NAME)-$(VERSION)-1.pe.$$(rpm -q --qf '%{EVR}' pe-puppet-enterprise-release | cut -d . -f 1-3,6).x86_64.rpm \
		--before-install package/rpm/preinstall \
		--after-install package/rpm/postinstall \
		--before-remove package/rpm/preuninstall \
		--after-remove package/rpm/postuninstall \
		--config-files /etc/puppetlabs/pds/pds-server.yaml \
		--config-files /etc/puppetlabs/pds/pds-client.yaml \
		--exclude '*/pds-server.yaml.example' \
		--exclude '*/pds-client.yaml.example' \
		--rpm-attr '0600,pds-server,pds-server:/etc/puppetlabs/pds/pds-server.yaml' \
		--rpm-attr '0640,pds-server,pe-puppet:/etc/puppetlabs/pds/pds-client.yaml' \
		--depends "pe-postgresql11 >= $$(rpm -q --qf '%{VERSION}' pe-postgresql11)" \
		app/=/opt/puppetlabs/server/apps/pds-server \
		app/config/pds-server.yaml.example=/etc/puppetlabs/pds/pds-server.yaml \
		golang/pds-cli/pds-cli=/opt/puppetlabs/bin/pds-cli \
		golang/pds-cli/pds-client.yaml.example=/etc/puppetlabs/pds/pds-client.yaml \
		package/pds=/etc/puppetlabs/puppet/trusted-external-commands/pds \
		package/pds-ctl=/opt/puppetlabs/sbin/pds-ctl \
		package/pds-server.service=/usr/lib/systemd/system/pds-server.service
	# Turn it back into a symlink when packaging is done
	cd app && rm openapi.yaml && ln -s ../docs/api.yml openapi.yaml

deb: $(bundle) $(pds-cli) $(fpm)
	# We don't want a symlink in the DEB, we want a regular file
	cd app && rm openapi.yaml && cp ../docs/api.yml openapi.yaml
	# Build the package
	$(fpm) -s dir -t deb -n $(NAME) -a x86_64 -v $(VERSION) \
		-p $(NAME)-$(VERSION)-1.pe.$$(dpkg-query --showformat='${Version}' --show pe-puppet-enterprise-release | cut -d . -f 1-3,6).amd64.deb \
		--before-install package/deb/preinstall \
		--after-install package/deb/postinstall \
		--before-remove package/deb/preuninstall \
		--after-remove package/deb/postuninstall \
		--config-files /etc/puppetlabs/pds/pds-server.yaml \
		--config-files /etc/puppetlabs/pds/pds-client.yaml \
		--exclude '*/pds-server.yaml.example' \
		--exclude '*/pds-client.yaml.example' \
		--depends "pe-postgresql11 >= $$(dpkg-query --showformat='${Version}' --show pe-postgresql11)" \
		app/=/opt/puppetlabs/server/apps/pds-server \
		app/config/pds-server.yaml.example=/etc/puppetlabs/pds/pds-server.yaml \
		golang/pds-cli/pds-cli=/opt/puppetlabs/bin/pds-cli \
		golang/pds-cli/pds-client.yaml.example=/etc/puppetlabs/pds/pds-client.yaml \
		package/pds=/etc/puppetlabs/puppet/trusted-external-commands/pds \
		package/pds-ctl=/opt/puppetlabs/sbin/pds-ctl \
		package/pds-server.service=/usr/lib/systemd/system/pds-server.service
	# Turn it back into a symlink when packaging is done
	cd app && rm openapi.yaml && ln -s ../docs/api.yml openapi.yaml  

clean:
	rm -rf app/vendor/bundle
	rm -f app/config/pds-server.yaml
	rm -f golang/pds-cli/pds-cli
	rm -f golang/pds-cli/pds-client.yaml
	rm -f pds-server*.rpm
	rm -f pds-server*.deb

$(pds-cli): $(go) $(wildcard golang/**/*.go)
	cd golang/pds-cli && go build

$(bundle): app/Gemfile app/Gemfile.lock
	cd app && PATH=$$PATH:/opt/puppetlabs/server/bin $(bundler) install --standalone \
		|| touch app/Gemfile.lock

# Require various build dependencies be installed and handled automatically, IF
# the build is running on Linux
ifeq ($(OS), Linux)
$(bundle): bundler $(pe-postgresql-devel)
$(pds-cli): $(go)
endif

bundler:
	$(gem) install bundler
	
$(pe-postgresql-devel):
	command -v yum && sudo yum install -y pe-postgresql11-devel  || sudo apt install -y pe-postgresql11-devel

$(go):
	command -v yum && sudo yum install -y golang || sudo apt install -y golang

$(fpm):
	sudo $(gem) install --no-document fpm
