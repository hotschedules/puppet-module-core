# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# Create directories from hiera data
#
class clabs::dirs {

  $dirs = hiera_hash('clabs::dirs', [])

  # Create dirs
  if ! empty($dirs) {
    create_resources('clabs::dir', $dirs)
  }

}

