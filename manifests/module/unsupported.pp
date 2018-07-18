# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker smartindent
#
# Convection Labs Module Initialization
#

#
# * Warn on unsupported module
#
define clabs::module::unsupported($msg = undef) {

  notify {
    "${name}_unsupported":
      message   => $msg ? {
        true    => $msg,
        default => "The module ${name} is not supported on \$osfamily == ${::osfamily}",
      },
      loglevel  => 'warning';
  }

}
