class puppet_data_service::server (
  String $database_host = getvar('facts.clientcert'),
  String $username,
  String $token,
) {

  File {
    owner => 'pds-server',
    group => 'pds-server',
    mode  => '0600',
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

  service { 'pds-server':
    ensure => running,
    enable => true,
  }

}
