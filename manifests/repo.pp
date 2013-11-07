define mirrorserver::repo (
  $baseurl,
  $description,
  $mirrorlist='',
  $baseurl='',
  $dest_dir,
  $order
)
{
  include mirrorserver
  include concat::setup
  
  $fulldestdir = "${mirrorserver::www_root}/${dest_dir}"

  $reposync_conf = $mirrorserver::reposync_conf

  concat::fragment {$name:
    target => $reposync_conf,
    order => $order,
    content => template('mirrorserver/reposync_conf.erb'),
  }

  $script = "${mirrorserver::mirror_script}"

  concat::fragment {"${name}_reposync_conf":
    target  => $script,
    content => template("mirrorserver/reposync.erb"),
    order   => $order,
  }

  
}
