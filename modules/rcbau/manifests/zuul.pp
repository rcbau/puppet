# == Class: rcbau::zuul
#
class rcbau::zuul(
  $vhost_name = $::fqdn,
  $gerrit_server = '',
  $gerrit_user = '',
  $zuul_ssh_private_key = '',
  $url_pattern = '',
  $zuul_url = '',
  $sysadmins = [],
  $statsd_host = '',
  $gearman_workers = [],
  $replication_targets = [],
  $status_url = 'http://status.rcbops.com/zuul/',
  $stop_puppet = false,
) {
  # Turn a list of hostnames into a list of iptables rules
  #$iptables_rules = regsubst ($gearman_workers, '^(.*)$', '-m state --state NEW -m tcp -p tcp --dport 4730 -s \1 -j ACCEPT')

  class { 'rcbau::server':
    iptables_public_tcp_ports => [80, 4730],
#    iptables_rules6           => $iptables_rules,  # This will need to be locked down.
#    iptables_rules4           => $iptables_rules,
    sysadmins                 => $sysadmins,
    stop_puppet               => $stop_puppet,
  }

  class { '::zuul':
    vhost_name           => $vhost_name,
    gerrit_server        => $gerrit_server,
    gerrit_user          => $gerrit_user,
    zuul_ssh_private_key => $zuul_ssh_private_key,
    url_pattern          => $url_pattern,
    zuul_url             => $zuul_url,
    job_name_in_report   => true,
    status_url           => $status_url,
    statsd_host          => $statsd_host,
  }

  file { '/etc/zuul/layout.yaml':
    ensure => present,
    source => 'puppet:///modules/rcbau/zuul/layout.yaml',
    notify => Exec['zuul-reload'],
  }

  file { '/etc/zuul/logging.conf':
    ensure => present,
    source => 'puppet:///modules/rcbau/zuul/logging.conf',
    notify => Exec['zuul-reload'],
  }

  file { '/etc/zuul/merger-logging.conf':
    ensure => present,
    source => 'puppet:///modules/rcbau/zuul/merger-logging.conf',
    notify => Exec['zuul-reload'],
  }

  file { '/etc/zuul/gearman-logging.conf':
    ensure => present,
    source => 'puppet:///modules/rcbau/zuul/gearman-logging.conf',
    notify => Exec['zuul-reload'],
  }

  # Start both the server and the merger
  class { '::zuul::server': }
  class { '::zuul::merger': }

  file { "/home/zuul/.gitconfig":
    ensure => present,
    source => 'puppet:///modules/rcbau/zuul/gitconfig',
    owner  => 'zuul',
    group  => 'zuul',
    mode   => '0664',
  }
}
