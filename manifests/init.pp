class mirrorserver (
  $www_root = $mirrorserver::params::www_root,
  $rsync_opts = $mirrorserver::params::rsync_opts,
  $mirror_script = $mirrorserver::params::mirror_script,
  $reposync_conf = $mirrorserver::params::reposync_conf,
  $lockfile = $mirrorserver::params::lockfile,
  $apache_simple_setup = true
  ) inherits mirrorserver::params
{
  include concat::setup
  
  file {$www_root:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0755,
  }

  exec {"set $www_root SELinux type":
    path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    command => "semanage fcontext -a -t httpd_sys_content_t \"$www_root(/.*)?\" && restorecon -R $www_root",
    # Either of these "unless" actions is ok, but the second one is
    # faster. The first more correctly checks for the exact rule above
    # though.
    unless  => "semanage fcontext -l | grep $www_root >/dev/null 2>&1",
    # unless  => "matchpathcon $www_root | grep httpd_sys_content_t >/dev/null 2>&1",
    require => File [$www_root],
  }

  concat {$mirror_script:
    owner  => root,
    group  => root,
    mode   => 0755,
  }

  concat::fragment {'script header':
    target  => $mirror_script,
    order   => 000,
    content => template('mirrorserver/script_header.erb'),
  }

  concat::fragment {'script footer':
    target  => $mirror_script,
    order   => 999,
    content => template('mirrorserver/script_footer.erb'),
  }

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

  if $apache_simple_setup {
    file {'/etc/httpd/conf.d/mirrorserver.conf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 0644,
      content => template('mirrorserver/mirrors.conf.erb'),
      notify  =>Service ['httpd'],
    }
  }
  else {
    file {'/etc/httpd/conf.d/mirrorserver.conf':
      ensure => absent,
      notify  =>Service ['httpd'],
    }
  }
}
