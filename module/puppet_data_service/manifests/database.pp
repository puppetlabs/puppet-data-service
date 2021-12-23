class puppet_data_service::database (
  Array[String] $allowlist = [$clientcert],
) {

  Pe_postgresql_psql {
    psql_user  => 'pe-postgres',
    psql_group => 'pe-postgres',
    psql_path  => '/opt/puppetlabs/server/bin/psql',
    port       => '5432',
    db         => 'postgres',
  }

  Pe_postgresql::Server::Pg_hba_rule {
    target      => '/opt/puppetlabs/server/data/postgresql/11/data/pg_hba.conf',
    user        => 'pds',
    description => 'none',
    type        => 'hostssl',
    database    => 'pds',
    auth_method => 'cert',
  }

  # Configure database

  pe_postgresql_psql { 'ROLE pds':
    unless  => "SELECT FROM pg_roles WHERE rolname = 'pds'",
    command => "CREATE ROLE pds CONNECTION LIMIT -1",
    before  => Pe_postgresql_psql['DATABASE pds'],
  }

  file { '/opt/puppetlabs/server/data/postgresql/11/pds':
    ensure => directory,
    owner  => 'pe-postgres',
    group  => 'pe-postgres',
    before => Pe_postgresql_psql['DATABASE pds'],
  }

  pe_postgresql_psql { 'TABLESPACE pds':
    unless  => "SELECT FROM pg_tablespace WHERE spcname = 'pds'",
    command => "CREATE TABLESPACE pds OWNER pds LOCATION '/opt/puppetlabs/server/data/postgresql/11/pds'",
    before  => Pe_postgresql_psql['DATABASE pds'],
  }

  pe_postgresql_psql { 'DATABASE pds':
    unless  => "SELECT datname FROM pg_database WHERE datname='pds'",
    command => "CREATE DATABASE pds TABLESPACE pds",
  }

  pe_postgresql_psql { 'DATABASE pds EXTENSION pgcrypto':
    require    => Pe_postgresql_psql['DATABASE pds'],
    db         => 'pds',
    unless     => "SELECT FROM pg_extension WHERE extname = 'pgcrypto'",
    command    => "CREATE EXTENSION pgcrypto",
  }

  # Configure pg_hba.conf

  # Proxy resource for notifications
  anchor { 'pds-pe_postgresql-notify': }

  $allowlist.each |$cn| {
    puppet_enterprise::pg::ident_entry { "pds-${cn}":
      pg_ident_conf_path => '/opt/puppetlabs/server/data/postgresql/11/data/pg_ident.conf',
      database           => 'pds',
      ident_map_key      => 'pds-map',
      client_certname    => $cn,
      user               => 'pds',
      notify             => Anchor['pds-pe_postgresql-notify'],
    }
    pe_postgresql::server::pg_hba_rule { "pds access for ${cn} (ipv4)":
      auth_option => "map=pds-map clientcert=${cn}",
      address     => '0.0.0.0/0',
      order       => '4',
      notify      => Anchor['pds-pe_postgresql-notify'],
    }
    pe_postgresql::server::pg_hba_rule { "pds access for ${cn} (ipv6)":
      auth_option => "map=pds-map clientcert=${cn}",
      address     => '::/0',
      order       => '5',
      notify      => Anchor['pds-pe_postgresql-notify'],
    }
  }

  # Relay notifications from the proxy resource to the service resource, if it
  # exists in the catalog
  Service <| name == 'pe-postgresql' |> {
    subscribe => Anchor['pds-pe_postgresql-notify'],
  }
}
