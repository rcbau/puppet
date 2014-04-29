# == Class: rcbau::server
#
# A server that we expect to run for some time
class rcbau::server (
  $iptables_public_tcp_ports = [],
  $iptables_public_udp_ports = [],
  $iptables_rules4           = [],
  $iptables_rules6           = [],
  $sysadmins                 = [],
  $certname                  = $::fqdn,
  $install_users             = false,
  $puppetmaster              = hiera('puppetmaster'),
) {
  class { 'openstack_project::template':
    iptables_public_tcp_ports => $iptables_public_tcp_ports,
    iptables_public_udp_ports => $iptables_public_udp_ports,
    iptables_rules4           => $iptables_rules4,
    iptables_rules6           => $iptables_rules6,
    certname                  => $certname,
    install_users             => $install_users,
  }
  class { 'exim':
    sysadmin => $sysadmins,
  }

  include rcbau::users
  realize (
    User::Virtual::Localuser['rcbau'],
    User::Virtual::Localuser['mattoliverau'],
  )

  include rcbau::motd_tail

  File <| title == "/etc/puppet/puppet.conf" |> { 
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('rcbau/puppet.conf.erb'),
    replace => true,
  }

  exec {'Add puppet-master to hosts': 
    command     => "echo '$puppetmaster puppet-master' >> /etc/hosts",
    path        => '/usr/local/bin:/usr/bin:/bin/',
    notify      => Service['puppet'],
    require     => File['/etc/puppet/puppet.conf'],
    onlyif      => '[ $(grep -c puppet-master /etc/hosts) -eq 0 ]',
  }

  exec {'Update puppet-master in hosts': 
    command     => "sed -i 's/^.* puppet-master/$puppetmaster puppet-master/' /etc/hosts",
    path        => '/usr/local/bin:/usr/bin:/bin/',
    notify      => Service['puppet'],
    require     => File['/etc/puppet/puppet.conf'],
    onlyif      => '[ $(grep -c puppet-master /etc/hosts) -gt 0 ]',
  }

  Service <| title == "puppet" |> {
    ensure  => running,
    enable  => true,
    require => [
        File['/etc/puppet/puppet.conf'],
        Exec['Add puppet-master to hosts'],
    ]
  }

  File <| title == "/etc/default/puppet" |> {
    ensure => present,
    source => 'puppet:///modules/rcbau/puppet.default',
    notify => Service['puppet']
  }

}

