# == Class: rcbau::users
#
class rcbau::users {
  @user::virtual::localuser { 'rcbau':
    realname => 'RCBAU Team',
    sshkeys  => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDEMVMT/ZEG8aQrBLRD9Q/4CnACgaEgono9z7kMzhi8oPKmlD92GeFamhcLPAb5tBlVx03vwomZDELaDaL/huU080XwoaHPjPl3nUitsA507ZKvjxkib1OWLwOV12sriqTVqCri/cHrSytSR+J+kFsERBzxrndurc9jsvHtf3PQxi661xW1R1uA0eHmC1BQRsKwl/vSllEwTxmY0Y7a2oGDuS0omHRgX4EFOTA+Nd0WNKzehokTOyPgc+42jG79n2Q89JlXlwfR9SROYaB+OoRHHKb3+Nfc2LhU0+OIqC3Dbak3plht/x8iHF8gUCuKCNMky3U0c0P37QmsUdy9HxSX",
  }

  @user::virtual::localuser { 'nodepool':
    realname => 'Nodepool User',
    sshkeys  => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCvMblkzC8J1bLhhfGu5ccOWeitkCctSzeX7+e7fnFT44Bjd3qR7OHWQ+ihNHQwDL4T0Z2oI8kKPxwcHTnRU4llnEPRJjUXWB5QTI6LvCFr5jCuh+X543OIgJtxF3UuoR6+lDVsHrJCU+X9Uwc7WWaPwnEPmb3+Wo8pTooYPgzk2O+hHn6blHXFianYSmMBV3t7amRhp1xA/DR3koI14ZQ2axlaTIiXVzY5bTugh62qnzt1ZVQafBCNNl+CRmuGO9dCkGcZfSAIg7Y/QM0U6P8t6S3FSeuHSmo0Y7/IOci+O9ddz5cfy1Ftm4DwswTudQ4fCCC4pULKKYfoCFyw3PPl",
  }

  @user::virtual::localuser { 'mattoliverau':
    realname => 'Matthew Oliver',
    sshkeys  => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCpFao/l3ouVrdkLjxBsvi2xBQOEhbcU+HxknXqy5tH4/gKoWBk8gHsOHIGPnADc4RTDjeAjWDezJwfTceBUVelYGSzlb70PvvMMb7SE+MkzPIKm9S7K9BJNYQbuaZPllRK3ErEBTOxhIDgVIjFGONx/bmO+jAoLjNiZpmTPZIco0qqNssjQVydvQazRd4+alX3wN4iw1HYFEs9uQQPQYsZ+FeGc1OvsVyZYTgl88MwfP/txoWEeMl49Ojx7Buj650/OXDSaHqI3eiZitan9ONMw6U6mefyHA0QU48ZIIHrxUNRD/s0wiCWlhCxMCCSsoXBIm9pkVUZxLqZVp6RrMCp",
  }
}
