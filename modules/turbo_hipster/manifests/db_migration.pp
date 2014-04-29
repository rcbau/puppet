# == Class: turbo_hipster::db_migration
#
class turbo_hipster::db_migration (
  $th_dataset_path = "/var/lib/turbo-hipster/",
  $th_user = $turbo_hipster::th_user,
  $th_test_user = "nova",
  $th_test_pass = "tester",
  $th_test_host = "%",
  $th_databases = [],
  $database_engine_package = "mysql-server",
  $database_engine = "mysql",
  $database_engine_bind = '0.0.0.0',
  $database_engine_port = '3306',
  $mysql_root_password,
  $charset     = 'utf8',
  $grant       = 'all',
  $ensure      = 'present',
  $mariadb_version = '5.5'

) {
  define database_engine_repo {
    if $database_engine == 'percona' {
      apt::source { 'percona':
        location   => 'http://repo.percona.com/apt',
        repos      => 'main',
        key        => '1C4CBDCDCD2EFD2A',
        key_server => 'keys.gnupg.net',
      }
    }
    elsif $database_engine == 'mariadb' {
      apt::source { 'mariadb':
        location   => "http://mirror.aarnet.edu.au/pub/MariaDB/repo/${mariadb_version}/ubuntu",
        repos      => 'main',
        key        => 'cbcb082a1bb943db',
        key_server => 'hkp://keyserver.ubuntu.com:80',
      }
    }
  }
  database_engine_repo { 'database_repo': }

  class { 'mysql::server':
    package_name => $database_engine_package,
    config_hash  => {
      'root_password'  => $mysql_root_password,
      'default_engine' => 'InnoDB',
      'bind_address'   => $database_engine_bind,
      'port'           => $database_engine_port,
    },
    require  => Database_engine_repo['database_repo'],
  }

  include mysql::python

  # first create the TH Test database user.
  database_user { "${th_test_user}@${th_test_host}":
    ensure        => $ensure,
    password_hash => mysql_password($th_test_pass),
    provider      => 'mysql',
    require       => Class['mysql::server'],
  }

  # define th_database so we can use an array to define all TH databases.
  define th_database {
    database { "$title":
      ensure   => $ensure,
      charset  => $charset,
      provider => 'mysql',
      require  => Class['mysql::server'],
    }

    if $ensure == 'present' {
      database_grant { "${th_test_user}@${th_test_host}/${title}":
        privileges => $grant,
        provider   => 'mysql',
        require    => Database_user["${th_test_user}@${th_test_host}"],
      }
    }
  }
  th_database { $th_databases:
    require =>  Database_user["${th_test_user}@${th_test_host}"],
  }

  file { '/etc/turbo-hipster/conf.d/db_migration.yaml':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => File['/etc/turbo-hipster/conf.d'],
    content => template('turbo_hipster/db_migration.yaml.erb'),
  }

  file { '/etc/turbo-hipster/start_TH_service.sh':
    ensure  => present,
    content => template('turbo_hipster/db_migration_start_TH_service.sh.erb'),
    mode    => '0750',
    owner   => 'root',
    group   => 'root',
    require => File['/etc/turbo-hipster'],
  }
}
