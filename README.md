# Puppet Data Service (PDS)

Puppet Data Service API

```
CLI / HieraBackend / TrustedExternal commands / Web Client?       golang/ | Client

---------------------------------------------------------------

                        API endpoints                             app/ | API Logic

---------------------------------------------------------------

      [PostgreSQL][Cassandra][MongoDB].                           app/lib/pds/data_adapter/ | DB Level
```

## Building the pds-service package

### Dependencies

* `fpm` must be installed
* `rpm` build tools must be installed

### Procedure

To build the pds-service RPM package

1. Checkout the project repo on a host of the OS type you would like to build the package for and change to that directory
3. Run `make clean`
4. Run `make package`

### Paths

```
Paths:
  /opt/puppetlabs/server/apps/pds-service
    - Application files

  /etc/puppetlabs/pds-service
    - Config files

  /opt/puppetlabs/bin
    - pds-cli executable

  /opt/puppetlabs/sbin
    - pds-rake wrapper script

  /etc/puppetlabs/puppet/trusted-external-commands/pds
    - Wrapper to `pds-cli node get --trusted-external-command $1`
```
