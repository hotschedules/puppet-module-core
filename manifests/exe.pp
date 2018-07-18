# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Define: clabs::exe
# ---
#
# File System Executable
#
# A wrapper around the {Puppet File Resource}[http://docs.puppetlabs.com/references/stable/type.html#file] for managing file system executables such as scripts and binaries.
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
# [*content*]
# - Default - *undef*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-content]
#
# [*source*]
# - Default - *undef*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-source]
#
# [*drive*]
# - Default (*Hiera*) - *clabs*::*exe*::*drive*
# - Description:
#     Prepends a location to the executable target. This provides
#     support for both Windows and Linux. The Linux default is '' since Linux
#     does not have the concept of drive locations. The Windows default is 'C:'.
#
# ==== Permissions
#
# [*seltype*]
# - Default - *undef*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-seltype]
#
# [*owner*]
# - Default (*Hiera*) - *clabs*::*exe*::*owner*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-owner]
#
# [*group*]
# - Default (*Hiera*) - *clabs*::*exe*::*group*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-group]
#
# [*mode*]
# - Default (*Hiera*) - *clabs*::*exe*::*mode*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-mode]
#
# [*sperms*]
# - Default (*Hiera*) - *clabs*::*exe*::*sperms*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-source_permissions]
# ==== Recursion
#
# [*recurse*]
# - Default - *false*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-recurse]
#
# [*purge*]
# - Default - *false*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-purge]
#
#
# === Examples
# ---
#
# [*Linux*]
#   Deploying a shell script using the default owner/perms:
# <code>clabs::exe { '/tmp/foo.sh': }</code>
#
# [*Windows*]
#   Deploying a powershell script using the default owner/perms while targetting the E: drive:
# <code>clabs::exe { '/tmp/foo.ps1': drive => 'E:' }</code>
#
define clabs::exe(
  # Targetting
  $replace  = true,
  $force    = false,
  $content  = undef,
  $source   = undef,
  $drive    = hiera('clabs::exe::drive'),

  # Permissions
  $seltype  = undef,
  $owner    = hiera('clabs::exe::owner'),
  $group    = hiera('clabs::exe::group'),
  $mode     = hiera('clabs::exe::mode'),
  $sperms   = hiera('clabs::exe::sperms'),

  # Recursion
  $recurse  = false,
  $purge    = false,
) {


  clabs::file {
    $name:
      replace => $replace,
      force   => $force,

      # Targetting
      content => $content,
      source  => $source,

      # Permissions
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      sperms  => $sperms,

      # Recursion
      purge   => $purge,
      recurse => $recurse,

      # Internal Use
      cmodname  => $caller_module_name,
      drive     => $drive,
  }


}

