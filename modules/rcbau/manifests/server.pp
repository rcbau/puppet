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

  realize (
    User::Virtual::Localuser['rcbau'],
    User::Virtual::Localuser['mattoliverau'],
  )
}

