# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker smartindent
#
# Convection Labs Module Initialization
#
#
# * Install any packages listed in a module's Hiera configuration
#
define clabs::module::packages() {

  $pkgs = getvar("::${name}::packages")

  if $pkgs {
    clabs::install { $pkgs: }
  }

}

