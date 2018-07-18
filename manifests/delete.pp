# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# Delete a file or directory
#
# Documentation: http://docs.puppetlabs.com/references/stable/type.html#file
#
define clabs::delete(
  $drive = hiera('clabs::default::drive'),
) {

  file {
    "${drive}${name}":
      ensure => absent,
  }

}

