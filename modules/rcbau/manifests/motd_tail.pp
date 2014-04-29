# == Class: rcbau::motd_tail
#
# Set the message of the day tail
class rcbau::motd_tail (
  $template = 'rcbau/motd/motd.tail.erb',
) {
  file { '/etc/motd.tail':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template($template),
  }
}
