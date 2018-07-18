# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker smartindent
#
# Convection Labs Module Initialization
#
#
# * Install any windows features listed in a module's Hiera configuration
#
define clabs::module::features() {

  $features = hiera("${name}::features", undef)

  if $features {
    ensure_resource('windowsfeature', $features, {
      require => Reboot['before'],
      notify  => Reboot['after'],
    })
  }

}

