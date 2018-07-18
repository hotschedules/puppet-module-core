# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker smartindent
#
# Convection Labs Module Initialization
#
# Initializes a given puppet module
#
# - loads all required classes
# - autoloads optional classes
#
define clabs::module::init($puppetreqver = '3.4.2') {

  if (versioncmp($puppetreqver, '3.4') == -1) {
    clabs::module::unsupported { $name:
      msg => 'Convection Labs Core requires Puppet version >= 3.4'
    }
  }

  if (versioncmp($::puppetversion, $puppetreqver) == -1) {
    clabs::module::unsupported { $name:
      msg => "The module ${name} requires Puppet version >= ${puppetreqver}"
    }
  }

  # *****************************************
  # *                                       *
  # *              Bootstrap                *
  # *              (OPTIONAL)               *
  # *                                       *
  # *****************************************
  $bname = "${name}::bootstrap"

  $have_bootstrap = defined($bname)

  if $have_bootstrap {
    class { $bname: stage => 'bootstrap'; }
  }

  # *****************************************
  # *                                       *
  # *          Virtual Resources            *
  # *              (OPTIONAL)               *
  # *                                       *
  # *****************************************
  $vname = "${name}::virtual"

  $have_virtual = defined($vname)

  if $have_virtual {
    contain $vname

    $pkgdep = Class[$vname]
  } else {
    $pkgdep = undef
  }

  # *****************************************
  # *                                       *
  # *           Windows Features            *
  # *              (OPTIONAL)               *
  # *                                       *
  # *****************************************

  if $::kernel == 'windows' {
    clabs::module::features { $name: }

    $idep = Clabs::Module::Features[$name]
  } else {
    $idep = Clabs::Module::Packages[$name]
  }

  # *****************************************
  # *                                       *
  # *             Installation              *
  # *              (OPTIONAL)               *
  # *                                       *
  # *****************************************

  $iname  = "${name}::install"
  $ikname = "${name}::install::${::kernel}"
  $ifname = "${name}::install::${::osfamily}"

  $have_install           = defined($iname)
  $have_install_kernel    = defined($ikname)

  # NOTE: osfamily & kernel may be the same on some OSes (e.g. windows)
  if ($::kernel != $::osfamily) {
    $have_install_osfamily  = defined($ifname)
  } else {
    $have_install_osfamily  = false
  }

  #
  # Automatic: Install packages from hiera data
  #
  clabs::module::packages { $name: require => $pkgdep; }

  #
  # Manual: Additional Installation Configuration
  #
  # Loads additional installation configurations AFTER any packages defined
  #   in hiera have been installed.
  #
  if $have_install {
    class { $iname: require => $idep; }
    contain $iname

    $ikdep = Class[$iname]
  } else {
    $ikdep = $idep
  }

  # *****************************************
  # *                                       *
  # *       OS Family & Kernel Install      *
  # *              (OPTIONAL)               *
  # *                                       *
  # *****************************************

  #
  # Kernel Extended Installation Configuration
  #
  if $have_install_kernel {
    class { $ikname: require => $ikdep; }
    contain $ikname

    $ifdep = Class[$ikname]
  } else {
    $ifdep = $ikdep
  }

  #
  # OS Family Extended Installation Configuration
  #
  if $have_install_osfamily {
    class { $ifname: require => $ifdep; }
    contain $ifname
  }

  # *****************************************
  # *                                       *
  # *            Configuration              *
  # *              (REQUIRED)               *
  # *                                       *
  # *****************************************

  $cname  = "${name}::config"
  $ckname = "${name}::config::${::kernel}"
  $cfname = "${name}::config::${::osfamily}"

  $have_config_kernel   = defined($ckname)

  # NOTE: osfamily & kernel may be the same on some OSes (e.g. windows)
  if ($::kernel != $::osfamily) {
    $have_config_osfamily = defined($cfname)
  } else {
    $have_config_osfamily = false
  }

  # Setup Config Class dependencies
  if $have_install_osfamily {
    $cdep = Class[$ifname]
  } elsif $have_install_kernel {
    $cdep = Class[$ikname]
  } elsif $have_install {
    $cdep = Class[$iname]
  } else {
    $cdep = Clabs::Module::Packages[$name]
  }

  # Load Config class
  class { $cname: require => $cdep; }
  contain $cname

  # *****************************************
  # *                                       *
  # *       OS Family & Kernel Config       *
  # *              (OPTIONAL)               *
  # *                                       *
  # *****************************************

  #
  # Kernel Extended Configuration
  #
  if $have_config_kernel {
    class { $ckname: require => Class[$cname] }
    contain $ckname

    $cfdep = Class[$ckname]
  } else {
    $cfdep = Class[$cname]
  }

  #
  # OS Family Extended Configuration
  #
  if $have_config_osfamily {
    class { $cfname: require => $cfdep; }
    contain $cfname
  }

  # *****************************************
  # *                                       *
  # *          Service Management           *
  # *              (OPTIONAL)               *
  # *                                       *
  # *****************************************

  $sname = "${name}::service"

  $have_service = defined($sname)

  # Setup Service Class dependencies
  if $have_config_osfamily {
    $svcdep = Class[$cfname]
  } elsif $have_config_kernel {
    $svcdep = Class[$ckname]
  } else {
    $svcdep = Class[$cname]
  }

  #
  # Manual: Service Class Defined (OVERRIDE)
  #
  if $have_service {
    class { $sname: require => $svcdep; }
    contain $sname
  #
  # Automatic: Service Data contained in Hiera
  #
  } else {
    $svcdata = getvar("::${name}::svc")

    if $svcdata {
      clabs::module::svcs {
        $name:
          svcdata => $svcdata,
          require => $svcdep,
      }
    }
  }

  # *****************************************
  # *                                       *
  # *             Mail Aliases              *
  # *              (OPTIONAL)               *
  # *                                       *
  # *****************************************

  $aliases = getvar("::${name}::mailalias")

  if $aliases {
    clabs::module::mailalias { $name: aliases => $aliases }
  }


}

