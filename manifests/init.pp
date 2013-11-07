class mirrorserver {

  include mirrorserver::params
  include apache
  include concat::setup
  
  $www_root = $mirrorserver::params::www_root
  
  file {$www_root:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0755,
  }
  
  $script = $mirrorserver::params::mirror_script
  $lockfile = $mirrorserver::params::lockfile
  
  concat {$script:
    owner  => root,
    group  => root,
    mode   => 0755,
  }

  concat::fragment {'script header':
    target  => $script,
    order   => 000,
    content => template('mirrorserver/script_header.erb'),
  }

  concat::fragment {'script footer':
    target  => $script,
    order   => 999,
    content => template('mirrorserver/script_footer.erb'),
  }

  $reposync_conf = $mirrorserver::params::reposync_conf

  concat {$reposync_conf:
    owner  => root,
    group  => root,
    mode   => 0644,
  }

  concat::fragment {'reposync conf header':
    target  => $reposync_conf,
    order   => 000,
    content => template('mirrorserver/reposync_header.erb'),
  }
  
  apache::vhost {'mirrors':
    priority => 10,
    port     => 80,
    docroot  => $www_root,
    require  => File [$www_root],
  }
}
