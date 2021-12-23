class puppet_data_service::server (
  String $database_host = getvar('facts.clientcert'),
  String $username,
  String $token,
) {
  # Used to ensure dependency ordering between this class and the database
  # class, if both are present in the catalog
  include puppet_data_service::anchor

  File {
    owner   => 'pds-server',
    group   => 'pds-server',
    mode    => '0600',
    require => Package['pds-server'],
    before  => Exec['pds-migrations'],
  }

  package { 'pds-server':
    ensure => installed,
  }

  file { '/etc/puppetlabs/pds-server/pds-cli.yaml':
    ensure  => present,
    content => to_yaml({
      'baseuri' => "http://${database_host}:8160/v1",
      'token'   => $token,
    }),
  }

  $cert_files = [
    File { '/etc/puppetlabs/pds-server/ssl':
      ensure => directory,
      mode   => '0700',
    },
    File { '/etc/puppetlabs/pds-server/ssl/cert.pem':
      ensure => file,
      source => "/etc/puppetlabs/puppet/ssl/certs/${clientcert}.pem",
    },
    File { '/etc/puppetlabs/pds-server/ssl/key.pem':
      ensure => file,
      source => "/etc/puppetlabs/puppet/ssl/private_keys/${clientcert}.pem",
    },
    File { '/etc/puppetlabs/pds-server/ssl/ca.pem':
      ensure => file,
      source => "/etc/puppetlabs/puppet/ssl/certs/ca.pem",
    },
  ]

  file { '/etc/puppetlabs/pds-server/pds.yaml':
    ensure  => present,
    require => $cert_files,
    notify  => Service['pds-server'],
    content => to_yaml({
      'database' => {
        'adapter'     => 'postgresql',
        'encoding'    => 'unicode',
        'pool'        => 2,
        'host'        => $database_host,
        'database'    => 'pds',
        'user'        => 'pds',
        'sslmode'     => 'verify-full',
        'sslcert'     => '/etc/puppetlabs/pds-server/ssl/cert.pem',
        'sslkey'      => '/etc/puppetlabs/pds-server/ssl/key.pem',
        'sslrootcert' => '/etc/puppetlabs/pds-server/ssl/ca.pem',
      },
    }),
  }

  exec { 'pds-migrations':
    unless  => '/opt/puppetlabs/sbin/pds-ctl rake db:migrate:status',
    command => @("CMD"/L),
      /opt/puppetlabs/sbin/pds-ctl rake db:migrate && \
      /opt/puppetlabs/sbin/pds-ctl rake 'app:set_admin_token[${token}]'
      | CMD
    require => Class['puppet_data_service::anchor'],
  }

  service { 'pds-server':
    ensure  => running,
    enable  => true,
    require => Exec['pds-migrations'],
  }

}
