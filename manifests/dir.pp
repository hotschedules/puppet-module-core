# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Define: clabs::dir
# ---
#
# File System Directory
#
# A wrapper around the {Puppet File Resource}[http://docs.puppetlabs.com/references/stable/type.html#file] for managing file system directories.
#
# === Parameters
# ---
#
# ==== Targetting
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
# - Default (*Hiera*) - *clabs*::*dir*::*drive*
# - Description:
#     Prepends a location to the directory target. This provides support for
#     both Windows and Linux. The Linux default is '' since Linux does not have
#     the concept of drive locations. The Windows default is 'C:'.
#
# ==== Permissions
#
# [*owner*]
# - Default (*Hiera*) - *clabs*::*dir*::*owner*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-owner]
#
# [*group*]
# - Default (*Hiera*) - *clabs*::*dir*::*group*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-group]
#
# [*mode*]
# - Default (*Hiera*) - *clabs*::*dir*::*mode*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-mode]
#
# [*seltype*]
# - Default - *undef*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-seltype]
#
#
# === Examples
# ---
#
# [*Linux*]
#   Using default owner/perms:
# <code>clabs::dir { '/tmp/foo': }</code>
#
# [*Windows*]
#   Using default owner/perms while targetting the E: drive:
# <code>clabs::dir { '/tmp/foo': drive => 'E:' }</code>
#
define clabs::dir(
  # Targetting
  $replace  = true,
  $force    = false,
  $drive    = hiera('clabs::dir::drive'),

  # Permissions
  $seltype  = undef,
  $owner    = hiera('clabs::dir::owner'),
  $group    = hiera('clabs::dir::group'),
  $mode     = hiera('clabs::dir::mode'),
) {

  file {
    "${drive}${name}":
      ensure  => directory,
      replace => $replace,
      force   => $force,

      # Permissions
      seltype => $seltype,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
  }

}

