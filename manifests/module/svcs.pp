# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker smartindent
#
# Convection Labs Module Initialization
#
#
#  name       => # (namevar) The name of the service to run.  This name is...
#  ensure     => # Whether a service should be running.  Valid...
#  binary     => # The path to the daemon.  This is only used for...
#  control    => # The control variable used to manage services...
#  enable     => # Whether a service should be enabled to start at...
#  hasrestart => # Specify that an init script has a `restart...
#  hasstatus  => # Declare whether the service's init script has a...
#  manifest   => # Specify a command to config a service, or a path
#  path       => # The search path for finding init scripts....
#  pattern    => # The pattern to search for in the process table...
#  provider   => # The specific backend to use for this `service...
#  restart    => # Specify a *restart* command manually.  If left...
#  start      => # Specify a *start* command manually.  Most...
#  status     => # Specify a *status* command manually.  This...
#  stop       => # Specify a *stop* command...
#
define clabs::module::svcs($svcdata) {

  # Set a default service status.
  #   The service status should match the module status.
  #   Enabled is implied if the module has been loaded and there is no explicit
  #   status defined.
  #
  $enabled = getvar("::${name}::enabled")

  validate_bool($enabled)

  $defaults = {
    ensure  => $enabled,
    enable  => $enabled,
  }

  case true {

    # Single service / no overrides
    is_string($svcdata): {
      ensure_resource('service', $svcdata, $defaults)
    }

    # Array of services
    is_array($svcdata): {
      ensure_resource('service', $svcdata, $defaults)
    }

    # Hash of services or an override of defaults
    is_hash($svcdata): {
      create_resources('service', $svcdata, $defaults)
    }

    # Error
    default: {
      notify { $name:
        message   => 'ERROR: service data must be a string or hash',
        loglevel  => 'crit';
      }
    }

  }

}

