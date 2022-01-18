# Puppet Data Service (PDS)

This project is owned by the Puppet Solutions Architects team. It is in an early stage of development and only intended to be used by Puppet Enterprise customers, in close collaboration with its developers.

## Summary

The Puppet Data Service (PDS) provides a centralized API-driven interface for Puppet node data and for Hiera data. PDS supports self-service use cases, and Puppet-as-a-Service (PUPaaS) use cases, providing a foundational mechanism for allowing service customer teams to get work done without requiring manual work to be performed by the PUPaaS team.

The PDS consists of:

1. A database backend. At present PostgreSQL is supported. Backends are pluggable, and support for other backends is planned.
2. An API service.
3. A command-line interface (CLI) for human operators.
3. Several Puppet integration components which let Puppet consume data from the API.
4. A Puppet module ([puppetlabs-puppet\_data\_service](https://github.com/puppetlabs/puppetlabs-puppet_data_service)) to aid in setup and configuration.

## Setup

Review the [puppetlabs-puppet\_data\_service](https://github.com/puppetlabs/puppetlabs-puppet_data_service) module for detailed information on how to install, configure, and run the service.

### Configuring the puppet_data_service module

1. Add the [puppetlabs-puppet\_data\_service](https://github.com/puppetlabs/puppetlabs-puppet_data_service) module to your control repo
   - Make sure to add the PDS hiera level in your control-repo's `hiera.yaml`
2. Configure the two required roles
   - The Database server
     - Add a new Node Group from the PE Console.
       ```
       Parent name: PE Infrastructure
       Group name: PDS Database
       Environment: production
       ```
     - Add the class `puppet_data_service::database` to the PDS Database group created in the step above
     - Add (pin) your PostgreSQL server certname in the Rules tab (it could be the primary server)
     - Commit your changes
   - Application server
     - In the **PE Master** Node group:
       - Add the new class `puppet_data_service::server`
       - Include the following parameters:
         - package_source: The location of the PDS RPM
         - database_host: The DB server cert
      - In the Configuration data tab:
         -  Configure the _sensitive_ `pds_token` parameter, this token will be used to create the admin account for the PDS, you can pass a UUID or your own token from your Active Directory/LDAP

## Development

The PDS [app](app/) folder contains detailed instructions to run the PDS API in a local development environment, as well as the CLI [golang](golang/) README file explains how to build and test the PDS CLI.

### Building the pds-server package

The following paths are included in the packaging of pds-server.

```
Paths:
  /opt/puppetlabs/server/apps/pds-server
    - Server application files

  /etc/puppetlabs/pds
    - Config files

  /opt/puppetlabs/bin
    - pds-cli executable

  /opt/puppetlabs/sbin
    - pds-ctl admin utility script

  /etc/puppetlabs/puppet/trusted-external-commands/pds
    - Wrapper to `pds-cli node get --trusted-external-command "$1"`
```

#### Packaging dependencies

* `fpm` must be installed
* `rpm` build tools must be installed

#### Procedure

To build the pds-server RPM package

1. Checkout the project repo on a host of the OS type you would like to build the package for and change to that directory
3. Run `make clean`
4. Run `make package`
