node 'nodepool.rcbops.com' {
  class { 'rcbau::nodepool':
    mysql_password           => hiera('nodepool_mysql_password'),
    mysql_root_password      => hiera('nodepool_mysql_root_password'),
    nodepool_ssh_private_key => hiera('nodepool_ssh_private_key_contents'),
    rackspace_username       => hiera('nodepool_rackspace_username'),
    rackspace_password       => hiera('nodepool_rackspace_password'),
    rackspace_project        => hiera('nodepool_rackspace_project'),
    git_source_repo          => 'https://github.com/matthewoliver/nodepool.git',
    puppetmaster             => hiera('puppetmaster'),
    revision                 => 'turbo-hipster',
    dataset_host             => hiera("th_dataset_host"),
    dataset_path             => hiera("th_dataset_path"),
    dataset_user             => hiera("th_dataset_user"),
  }
}

node 'zuul-test.rcbops.com' {
  class { 'rcbau::zuul':
    gerrit_server        => 'review.openstack.org',
    gerrit_user          => 'turbo-hipster',
    zuul_ssh_private_key => hiera('zuul_ssh_private_key_contents'),
    zuul_url             => 'http://zuul-test.rcbops.com/p',
  }
}

# The following nodes come from nodepool where the hostname is hardcoded
# to have template.openstack.org appended. This should be fixed in nodepool
# upstream

node /th-mysql-(\d+\.template|.*\.slave)\.openstack\.org$/ {
  class { 'rcbau::turbo_hipster':
    mysql_root_password => hiera('nodepool_mysql_root_password'),
    rs_cloud_user       => hiera("th_rackspace_user"),
    rs_cloud_pass       => hiera("th_rackspace_pass"),
    gearman_server      => 'zuul.rcbops.com',
    ssh_private_key     => hiera("th_private_ssh_key"),
    #TODO(mattoliverau) - the following 3 dataset lines can be removed
    dataset_host        => hiera("th_dataset_host"),
    dataset_path        => hiera("th_dataset_path"),
    dataset_user        => hiera("th_dataset_user"),
    manage_start_script => false,
  }

  realize (
    User::Virtual::Localuser['nodepool'],
  )
}

node /th-percona-(\d+\.template|.*\.slave)\.openstack\.org$/ {
  class { 'rcbau::turbo_hipster':
    mysql_root_password      => hiera('nodepool_mysql_root_password'),
    database_engine_package  => "percona-server-server",
    database_engine          => "percona",
    rs_cloud_user            => hiera("th_rackspace_user"),
    rs_cloud_pass            => hiera("th_rackspace_pass"),
    gearman_server           => 'zuul.rcbops.com',
    ssh_private_key          => hiera("th_private_ssh_key"),
    #TODO(mattoliverau) - the following 3 dataset lines can be removed
    dataset_host             => hiera("th_dataset_host"),
    dataset_path             => hiera("th_dataset_path"),
    dataset_user             => hiera("th_dataset_user"),
    manage_start_script      => false,
  }

  realize (
    User::Virtual::Localuser['nodepool'],
  )
}

node /th-mysql-debug-(\d+\.template|.*\.slave)\.openstack\.org$/ {
  class { 'rcbau::turbo_hipster':
    mysql_root_password => hiera('nodepool_mysql_root_password'),
    rs_cloud_user       => hiera("th_rackspace_user"),
    rs_cloud_pass       => hiera("th_rackspace_pass"),
    gearman_server      => 'zuul.rcbops.com',
    ssh_private_key     => hiera("th_private_ssh_key"),
    #TODO(mattoliverau) - the following 3 dataset lines can be removed
    dataset_host        => hiera("th_dataset_host"),
    dataset_path        => hiera("th_dataset_path"),
    dataset_user        => hiera("th_dataset_user"),
    manage_start_script => false,
    shutdown_check      => false,
    debug_str           => '-debug',
  }

  realize (
    User::Virtual::Localuser['nodepool'],
  )
}

node /th-percona-debug-(\d+\.template|.*\.slave)\.openstack\.org$/ {
  class { 'rcbau::turbo_hipster':
    mysql_root_password      => hiera('nodepool_mysql_root_password'),
    database_engine_package  => "percona-server-server",
    database_engine          => "percona",
    rs_cloud_user            => hiera("th_rackspace_user"),
    rs_cloud_pass            => hiera("th_rackspace_pass"),
    gearman_server           => 'zuul.rcbops.com',
    ssh_private_key          => hiera("th_private_ssh_key"),
    #TODO(mattoliverau) - the following 3 dataset lines can be removed
    dataset_host             => hiera("th_dataset_host"),
    dataset_path             => hiera("th_dataset_path"),
    dataset_user             => hiera("th_dataset_user"),
    manage_start_script      => false,
    shutdown_check           => false,
    debug_str           => '-debug',
  }

  realize (
    User::Virtual::Localuser['nodepool'],
  )
}

node /th-maria-(\d+\.template|.*\.slave)\.openstack\.org$/ {
  class { 'rcbau::turbo_hipster':
    mysql_root_password      => hiera('nodepool_mysql_root_password'),
    database_engine_package  => "mariadb-server",
    database_engine          => "mariadb",
    rs_cloud_user            => hiera("th_rackspace_user"),
    rs_cloud_pass            => hiera("th_rackspace_pass"),
    gearman_server           => 'zuul.rcbops.com',
    ssh_private_key          => hiera("th_private_ssh_key"),
    #TODO(mattoliverau) - the following 3 dataset lines can be removed
    dataset_host             => hiera("th_dataset_host"),
    dataset_path             => hiera("th_dataset_path"),
    dataset_user             => hiera("th_dataset_user"),
    manage_start_script      => false,
  }

  realize (
    User::Virtual::Localuser['nodepool'],
  )
}

node /th-cookbooks-\d+\.template\.openstack\.org$/ {
  class { 'rcbau::turbo_hipster':
    rs_cloud_user            => hiera("th_rackspace_user"),
    rs_cloud_pass            => hiera("th_rackspace_pass"),
    gearman_server           => 'zuul.rcbops.com',
    ssh_private_key          => hiera("th_private_ssh_key"),
    plugin                   => 'cookbooks_ci',
  }

  realize (
    User::Virtual::Localuser['nodepool'],
  )
}
