# Validating Backup and Restore Workflow

In this docs folder you will also find two shell scipts which are simple examples of how to backup data currently stored in PDS and then restore that data to a fresh and empty PDS. The PDS API's bulk add feature does not handle duplicate entires so the PDS database must be empty to restore, this is very much a disaster recovery workflow and not a way to roll back accidental changes.

For the same issue with duplicates the sample backup script strips the admin user from the dump received from the API before it packages it into a tarball. You will need to at minimum have the admin user re-initialized before doing a restore.

### Install dependencies

`yum install jq`

### Save backup archive to /tmp

`./backup.sh /tmp`

### Re-initialize database

You only do this if you are explicitly testing functionality. If you're actually restoring after failure then this is unnessasary because the database should already be empty.

```
systemctl stop pds-server
puppet resource pe_postgresql_psql drop psql_user='pe-postgres' psql_group='pe-postgres' psql_path='/opt/puppetlabs/server/bin/psql' port='5432' db='postgres' command='DROP DATABASE pds'
puppet resource pe_postgresql_psql drop psql_user='pe-postgres' psql_group='pe-postgres' psql_path='/opt/puppetlabs/server/bin/psql' port='5432' db='postgres' command='CREATE DATABASE pds TABLESPACE pds'
puppet resource pe_postgresql_psql drop psql_user='pe-postgres' psql_group='pe-postgres' psql_path='/opt/puppetlabs/server/bin/psql' port='5432' db='postgres' command='CREATE EXTENSION pgcrypto' db=pds
/opt/puppetlabs/sbin/pds-ctl rake db:migrate
/opt/puppetlabs/sbin/pds-ctl rake app:set_admin_token[admin-token]
systemctl start pds-server
```
### Restore backup from archive

`./restore.sh /tmp/pds-backup-2022-01-25T22\:27\:56+00\:00.tar.gz`