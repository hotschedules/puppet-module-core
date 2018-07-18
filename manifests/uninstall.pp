# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# Uninstalls Packages
#
define clabs::uninstall() {

  if !defined(Package[$name]) {
    package { $name: ensure => absent }
  }

}

