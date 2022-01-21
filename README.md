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

## Development

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

## Disaster Recovery

All Puppet Data Service (PDS) implementations have a Backend Storage Service (BSS) which is either a source of truth or a cached version of an external source of truth to facilitate better integration with Puppet. In both scenarios you must plan for regular backups of the BSS to reduce RTO and prevent data loss. Backup and restore operations should be initiated through the PDS API. The PDS API can bulk output and load JSON via flat files, making the backup and restore procedure independent from the technology chosen to implement durable storage for the BSS.

### Recovery Time Objective

RTO of a PDS deployment is dependent in large upon the BSS implementation. The actual API service is fairly simple and deploys quickly, data stored in the BSS is not complex, primarily made up of key/value pairs and lacking of any relationships.

This PDS implementation has the Puppet Enterprise customer as the primary user in mind and in that context the BSS is backed by PE PostgreSQL so a loss of the PDS BSS likely coincides with a loss of PE services. To restore PDS services PE must be online so the RTO is calculated as `RTO of PE + PDS API deployment time + BSS data restore time`. In an average scenario a **2 hour** RTO is reasonable but will flux dependent upon the time it takes to restore PE services and the quantity of data that was stored in the BSS.

Scenarios where the PDS is not dependent on the functionality of PE can usually be recovered in less time. This is simply the fact that to obtain a database from PE you must restore the entirety of PE, if PE is not a factor then an independent database can be provisioned to house restored data. The time to online a non-PE dependent PDS service is at least half of the time it takes to online a PE dependent installation. In the average scenario a **1 hour** RTO is reasonable. This is calculated by taking `BSS backend database deployment time + PDS API deployment time + BSS data restore time`.

### Recovery Point Objective

RPO of a PDS deployment is entirely dependent on the rate of change pushed by users and how you address that rate of change with your backup schedule. The RPO is calculated by Timestamp of service loss - Timestamp of last backup. This number will be the number of hours of data loss that will need to be inputted manually or obtained from an external source of truth.

How feasible obtaining lost data is depends on rate of change. If you only see a few changes a day then daily backups will be sufficient but if change rate is dozens per hour then a more frequent backup schedule is ideal. Having to manually input incremental data not found in your latest backup through the PDS API could become overly time consuming, affecting your Recovery Time Actual (RTA).

### Backup and Restore Procedure

The basic procedure for backing up the PDS is issuing a GET to each API endpoint, once for users, hiera-data, and nodes to output all values as a single JSON blob. Nothing else must be done except to save this output to a file. The resulting file is what you use to restore data after failure.

Loading data from the backup file for a restore requires a POST to each API endpoint.

Exampleshell scripts that implement the backup and restore workflow can be found [here](docs/backup.sh) and [here](docs/restore.sh).

