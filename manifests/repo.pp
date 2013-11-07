define mirrorserver::repo (
  $baseurl,
  $description,
  $mirrorlist='',
  $baseurl='',
  $dest_dir,
  $order
)
{
  $fulldestdir = "${mirrorserver::params::www_root}/${dest_dir}"

  $reposync_conf = $mirrorserver::params::reposync_conf

  concat::fragment {$name:
    target => $reposync_conf,
    order => $order,
    content => template('mirrorserver/reposync_conf.erb'),
  }

  $script = "${mirrorserver::params::mirror_script}"

  concat::fragment {"${name}_reposync_conf":
    target  => $script,
    content => template("mirrorserver/reposync.erb"),
    order   => $order,
  }

  
}
