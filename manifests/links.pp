# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# Create symlinks from hiera data
#
class clabs::links {

  $links = hiera_hash('clabs::links', [])

  # Create dirs
  if ! empty($links) {
    create_resources('clabs::link', $links)
  }

}