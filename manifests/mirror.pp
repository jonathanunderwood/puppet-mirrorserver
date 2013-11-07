define mirrorserver::mirror (
  $source,
  $dest_dir,
  $mirror_method = 'rsync', # At the moment only rsync is implemented
  $rsync_opts = undef,
  $order
) {
  include mirrorserver
  include concat::setup
  
  validate_re($mirror_method, "^rsync$")
  
  $fulldestdir = "${mirrorserver::www_root}/${dest_dir}"
  $script = "${mirrorserver::mirror_script}"
  
  if $mirror_method == 'rsync' {
    if $rsync_opts == undef {
      $rsyncopts = $mirrorserver::rsync_opts
    }
    else {
      $rsyncopts = $rsync_opts
    }
    
    concat::fragment {$name:
      target  => $script,
      content => template("mirrorserver/rsyncmirror.erb"),
      order   => $order,
    }
  }
}
