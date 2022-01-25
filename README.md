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

Here is detailed information to install, configure, and run the service using the [puppetlabs-puppet\_data\_service](https://github.com/puppetlabs/puppetlabs-puppet_data_service) module

The `puppet_data_service` module will install the whole PDS [via its RPM](https://github.com/puppetlabs/puppet-data-service/releases) for you, so you don't have to worry about operationalizing the PDS service itself, dealing with DB setup, migrations, and so on, also it will install the PDS CLI as well.

**Required configuration parameters**

* `puppet_data_service::database_host`
* `puppet_data_service::pds_token`

**Optional configuration parameters**

* `puppet_data_service::package_source`

### Configure using the PE Console

This setup will help you to quickly configure the PDS in your existing PE server, for advanced Puppet users review the *Configure using roles and Hiera eyaml* section.

1. Add the [puppetlabs-puppet\_data\_service](https://github.com/puppetlabs/puppetlabs-puppet_data_service) module to your control repo
   - Make sure to add the PDS hiera level in your control-repo's `hiera.yaml`
2. Configure the two required `roles`
   - The Database server
     - Add a new Node Group from the PE Console.
       ```
       Parent name: PE Infrastructure
       Group name: PDS Database
       Environment: production
       ```
     - Add the class `puppet_data_service::database` to the PDS Database group created in the step above
     - Add (pin) your existing PostgreSQL server `certname` in the Rules tab (it could be the primary server)
       - In case you want to test the PDS in a different server without PostgreSQL, you can apply the `puppet_enterprise::profile::database` class to your node before following these steps, 
     - Commit your changes
   - PDS API server
     - In the **PE Master** Node group:
       - Add the new class `puppet_data_service::server`
       - Include the following parameters:
         - package_source: The location of the PDS RPM
         - database_host: The DB server `certname`
      - In the Configuration data tab:
         -  Configure the _sensitive_ `pds_token` parameter, this token will be used to create the admin account for the PDS, you can pass a UUID or your own token from your Active Directory/LDAP
      - Commit your changes
3. Run the Puppet Agent

### Configure using roles and Hiera eyaml

If you are an experienced Puppet practicioner, this other configuration option will give you the tools you need to make your own Puppet `roles`

Include the `puppet_data_service` classes in the corresponding `role`

**The PDS Database server**

```
# control-repo/site-modules/role/manifests/pds_database_server.pp

class role::pds_database_server {
  include puppet_data_service::database
}
```

**The PDS API server**

```
# control-repo/site-modules/role/manifests/pds_api_server.pp

class role::pds_api_server {
  include puppet_data_service::server

  class { 'puppet_data_service::server':
    database_host => 'database.example.com',
    pds_token     => Sensitive('a-secure-admin-token'),
  }
}
```

Since the `pds_token` is a sensitive parameter, it will be a good idea to encrypt it using [Hiera eyaml](https://github.com/voxpupuli/hiera-eyaml).

`eyaml encrypt -l 'puppet_data_service::pds_token' -s 'a-secure-admin-token'`

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

## User guide

As a PDS user you currently have two options to interact with it.

1. PDS CLI
2. PDS API

This user guide will focus on the PDS CLI, but if you want to create your own PDS client (e.g. web app) check the [PDS API documentation](docs/)

The CLI offers you a convinient way to create and retrieve data from the PDS. You can interact with it by typing in your Puppet Server's terminal:

```
pds-cli
```

[The PDS CLI documentation](golang/pds-cli/doc/pds-cli.md) section has detailed instructions of the available options