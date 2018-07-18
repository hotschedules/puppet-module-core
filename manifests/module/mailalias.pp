# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker smartindent
#
# Convection Labs Module Initialization
#
#
define clabs::module::mailalias($aliases) {

  $defaults = {
    recipient => hiera('clabs::module::mailalias::recipient')
  }

  # Only supported on Linux
  if $::kernel == 'Linux' {
    create_resources('mailalias', $aliases, $defaults)
  }

}

