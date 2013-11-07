class mirrorserver::params (
  $www_root = '/srv/www/mirrors',
  $rsync_opts = '-arv --delete',
  $mirror_script = '/srv/scripts/sync-mirrors.sh',
  $reposync_conf = '/srv/scripts/reposync.conf',
  $lockfile = '/var/lock/subsys/sync-mirrors'
)
{
# Nothing
}
