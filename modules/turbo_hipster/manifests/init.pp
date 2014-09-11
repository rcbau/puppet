# == Class: turbo-hipster
#
class turbo_hipster (
  $th_repo = 'https://git.openstack.org/stackforge/turbo-hipster', 
  $th_repo_destination = '/opt/turbo-hipster',
  $th_repo_branch = "master",
  $th_dataset_path = "/var/lib/turbo-hipster/",
  $th_user = "th",
  $gerrit_site = "http://review.openstack.org",
  $git_origin = "git://git.openstack.org",
  $gearman_server = "",
  $gearman_port = 4730,
  $pypi_mirror = "http://pypi.python.org",
  $ssh_private_key = "",
  $rs_cloud_user = "",
  $rs_cloud_pass = "",
  $manage_start_script = true,
  $shutdown_check = true,
) {

  include pip

  user { "$th_user":
    ensure     => present,
    home       => "/home/$th_user",
    shell      => '/bin/bash',
    gid        => $th_user,
    groups     => ['adm',],
    managehome => true,
    require    => Group[$th_user],
    notify     => Vcsrepo["$th_repo_destination"],
  }

  group { "$th_user":
    ensure => present,
  }

  vcsrepo { "$th_repo_destination":
    ensure   => latest,
    provider => git,
    revision => $th_repo_branch,
    source   => $th_repo,
    notify   => Exec['install_th_dependencies'],
    require  => User["$th_user"],
  }

  define pip_conf {
    file { "${title}/.pip":
      ensure  => directory,
      mode    => '0755',
    }

    file { "${title}/.pip/pip.conf":
      ensure  => present,
      mode    => '0644',
      require => File['/etc/turbo-hipster'],
      content => template('turbo_hipster/pip.conf.erb'),
    }
  }

#  pip_conf {  ['/root/', "/home/$th_user/"]:
#    require => User["$th_user"],
#  }

  file { '/var/cache/pip':
    ensure => directory,
    mode   => '0777',
    owner  => 'root',
    group  => 'root',
  }

  package { 'libmysqlclient-dev':
    ensure => present,
  }

#  exec { 'Uninstall pip version 4':
#    command     => "pip uninstall -y setuptools",
#    path        => '/usr/local/bin:/usr/bin:/bin/',
#    refreshonly => true,
#    onlyif      => "[ $(pip list |grep setuptools |grep -c 4.0) -gt 0 ]",
#  }

  exec { 'install_th_dependencies' :
    command     => "pip install $th_repo_destination",
    path        => '/usr/local/bin:/usr/bin:/bin/',
    refreshonly => true,
    notify      => Exec['install_turbo-hipster'],
    onlyif      => "[ -e $th_repo_destination ]",
#    subscribe   => Vcsrepo["$th_repo_destination"],
    require     => [
      Class['pip'],
      File['/var/cache/pip'],
      Vcsrepo["$th_repo_destination"],
      Package['libmysqlclient-dev'],
#      Exec['Uninstall pip version 4'],
    ],
  }

  file { '/etc/turbo-hipster':
    ensure => directory,
  }

  file { '/etc/turbo-hipster/conf.d':
    ensure  => directory,
    require => File['/etc/turbo-hipster'],
  }

  if ($manage_start_script) {
    file { '/etc/turbo-hipster/start_TH_service.sh':
      ensure  => present,
      content => template('turbo_hipster/start_TH_service.sh.erb'),
      mode    => '0750',
      owner   => 'root',
      group   => 'root',
      require => File['/etc/turbo-hipster'],
    }
  }

# This config in the future will need to be split config.json and config.json.d/ so each plugin can contain place each piece of their configuration.
  file { '/etc/turbo-hipster/config.yaml':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => File['/etc/turbo-hipster'],
    content => template('turbo_hipster/config.yaml.erb'),
  }

  file { '/etc/init.d/turbo-hipster':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('turbo_hipster/init_turbo-hipster.erb'),
  }

  file { '/var/log/turbo-hipster':
    ensure => directory,
    mode   => '0755',
    owner  => $th_user,
    group  => $th_user,
  }

  file { '/var/lib/turbo-hipster':
    ensure  => directory,
    mode    => '0755',
    owner   => $th_user,
    group   => $th_user,
    require => User[$th_user],
  }

  file { '/var/lib/turbo-hipster/git':
    ensure  => directory,
    mode    => '0755',
    owner   => $th_user,
    group   => $th_user,
    require => File['/var/lib/turbo-hipster'],
  }

  file { '/var/lib/turbo-hipster/jobs':
    ensure  => directory,
    mode    => '0755',
    owner   => $th_user,
    group   => $th_user,
    require => File['/var/lib/turbo-hipster'],
  }

  exec { 'install_turbo-hipster':
    command   => "python setup.py install",
    cwd       => "$th_repo_destination",
    path      => '/usr/local/bin:/usr/bin:/bin/',
#    subscribe => Vcsrepo["$th_repo_destination"],
    require   => [
      Vcsrepo["$th_repo_destination"],
      Exec['install_th_dependencies'],
    ],
    onlyif    => "[ -e $th_repo_destination ]",
  }

  file { "/home/${th_user}/.ssh":
    ensure  => directory,
    mode    => '0500',
    owner   => $th_user,
    group   => $th_user,
    require => User["$th_user"],
  }

  file { "/home/${th_user}/.ssh/id_rsa":
    ensure  => present,
    content => $ssh_private_key,
    mode    => '0400',
    owner   => $th_user,
    group   => $th_user,
    require => File["/home/${th_user}/.ssh"],
  }

  file { "/home/${th_user}/.ssh/config":
    ensure  => present,
    source  => 'puppet:///modules/turbo_hipster/ssh.config',
    mode    => '0440',
    owner   => $th_user,
    group   => $th_user,
    require => File["/home/${th_user}/.ssh"],
  }

#  exec { 'start_turbo-hipster':
#    command   => '/etc/turbo-hipster/start_turbo-hipster.sh',
#    path      => '/usr/local/bin:/usr/bin:/bin/',
#    subscribe => Vcsrepo[$th_repo_destination],
#    require   => [
#      File['/etc/turbo-hipster/start_turbo-hipster.sh'],
#      File['/var/log/turbo-hipster'],
#      File["/home/${th_user}/.ssh/id_rsa"],
#      File["/var/lib/turbo-hipster"],
#    ],
#  }

#  cron { 'Start Turbo-Hipster at boot':
#    command => '/etc/turbo-hipster/start_turbo-hipster.sh',
#    user    => 'root',
#    special => 'reboot',
#    require => File['/etc/turbo-hipster/start_turbo-hipster.sh'],
#  }

  exec { 'Start Turbo-Hipster at boot (rc.local)':
    command => "echo /etc/turbo-hipster/start_TH_service.sh >> /etc/rc.local",
    path    => '/usr/local/bin:/usr/bin:/bin/',
    onlyif  => '[ $(grep -ic /etc/turbo-hipster/start_TH_service.sh /etc/rc.local) -eq 0 ]',
    require => File['/etc/turbo-hipster/start_TH_service.sh'],
  }

  # FIXME: This is a horrible hack to get a version of virtualenv >= 1.11
  # This will run every time but since it's only ran once on slaves it'll do
  # until we fix the versioning properly
  exec { 'update-virtualenv':
    command   => "pip install -U setuptools virtualenv pip virtualenvwrapper",
    path      => '/usr/local/bin:/usr/bin:/bin/',
    require   => Class['pip'],
  }

  file { '/etc/sudoers.d/th':
    ensure => present,
    mode   => '0440',
    owner  => 'root',
    group  => 'root',
    content => template('turbo_hipster/th.sudoers.erb'),
  }

  file { '/etc/turbo-hipster/shutdown_TH.sh':
    ensure  => present,
    mode    => '0750',
    owner   => 'root',
    group   => 'root',
    require => File['/etc/turbo-hipster'],
    source  => 'puppet:///modules/turbo_hipster/shutdown_TH.sh',
  }

  if ($shutdown_check) {
    cron { 'Add TH shutdown check':
      command => '/etc/turbo-hipster/shutdown_TH.sh',
      user    => 'root',
      minute  => '*/5',
      require => File['/etc/turbo-hipster/shutdown_TH.sh'],
    }
  }
}
