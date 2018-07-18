# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Define: clabs::link
# ---
#
# File System Link
#
# A wrapper around the {Puppet File Resource}[http://docs.puppetlabs.com/references/stable/type.html#file] for managing file system links (UNIX).
#
# === Parameters
# ---
#
# ==== Targetting
#
# [*name*]
# - Default - NONE (REQUIRED)
# - Fully qualified link source
#
# [*replace*]
# - Default - *true*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-replace]
#
# [*force*]
# - Default - *false*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-force]
#
# [*drive*]
# - Default (*Hiera*) - *clabs*::*link*::*drive*
# - Description:
#     Prepends a location to the link SOURCE. This provides support for
#     both Windows and Linux. The Linux default is '' since Linux does not have
#     the concept of drive locations. The Windows default is 'C:'.
#
# [*target*]
# - Default - NONE (REQUIRED PARAM)
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-target]
#
# [*targetdrive*]
# - Default (*Hiera*) - *clabs*::*link*::*targetdrive*
# - Description:
#     Prepends a location to the link TARGET. This provides support for
#     both Windows and Linux. The Linux default is '' since Linux does not have
#     the concept of drive locations. The Windows default is 'C:'.
#
# ==== Permissions
#
# [*seltype*]
# - Default - *undef*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-seltype]
#
# [*owner*]
# - Default (*Hiera*) - *clabs*::*link*::*owner*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-owner]
#
# [*group*]
# - Default (*Hiera*) - *clabs*::*link*::*group*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-group]
#
# [*mode*]
# - Default (*Hiera*) - *clabs*::*link*::*mode*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-mode]
#
# === Examples
# ---
#
define clabs::link(

  # Targetting

  $target,

  $replace  = true,
  $force    = false,
  $drive    = hiera('clabs::link::drive', 
    $::kernel ? {
      'windows' => 'C:',
      default   => undef,
    }
  ),
  $targetdrive = hiera('clabs::link::targetdrive',
    $::kernel ? {
      'windows' => 'C:',
      default   => undef,
    }
  ),

  # Permissions

  $seltype  = undef,
  $owner    = hiera('clabs::link::owner',
    $::kernel ? {
      'windows' => 'SYSTEM',
      default   => 'root',
    }
  ),
  $group    = hiera('clabs::link::group',
    $::kernel ? {
      'windows' => 'Administrators',
      default   => 'adm',
    }
  ),
  $mode     = hiera('clabs::link::mode',
    $::kernel ? {
      'windows' => '644',
      default   => '444',
    }
  ),

) {

  file {
    "${drive}${name}":
      ensure  => link,
      replace => $replace,
      force   => $force,
      target  => "${targetdrive}/${target}",

      # Permissions
      seltype => $seltype,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
  }

}

