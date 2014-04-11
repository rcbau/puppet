# == Class: rcbau::users
#
class rcbau::users {
  @user::virtual::localuser { 'rcbau':
    realname => 'RCBAU Team',
    sshkeys  => hiera("root_ssh_public_key"),
  }

  @user::virtual::localuser { 'nodepool':
    realname => 'Nodepool User',
    sshkeys  => hiera("nodepool_ssh_public_key"),
  }

  @user::virtual::localuser { 'mattoliverau':
    realname => 'Matthew Oliver',
    sshkeys  => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpFao/l3ouVrdkLjxBsvi2xBQOEhbcU+HxknXqy5tH4/gKoWBk8gHsOHIGPnADc4RTDjeAjWDezJwfTceBUVelYGSzlb70PvvMMb7SE+MkzPIKm9S7K9BJNYQbuaZPllRK3ErEBTOxhIDgVIjFGONx/bmO+jAoLjNiZpmTPZIco0qqNssjQVydvQazRd4+alX3wN4iw1HYFEs9uQQPQYsZ+FeGc1OvsVyZYTgl88MwfP/txoWEeMl49Ojx7Buj650/OXDSaHqI3eiZitan9ONMw6U6mefyHA0QU48ZIIHrxUNRD/s0wiCWlhCxMCCSsoXBIm9pkVUZxLqZVp6RrMCp\n",
  }
}
