# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Define: clabs::file
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
# - Default - *true*
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
#     Prepends a string to the executable target. This provides
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
# [*ignore*]
# - Default - (*Hiera*) - *clabs*::*exe*::*ignore*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-ignore]
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
define clabs::file(
  # Targetting
  $replace  = true,
  $force    = false,
  $content  = undef,
  $source   = undef,
  $drive    = hiera('clabs::file::drive'),

  # Permissions
  $seltype  = undef,
  $owner    = hiera('clabs::file::owner'),
  $group    = hiera('clabs::file::group'),
  $mode     = hiera('clabs::file::mode'),
  $sperms   = hiera('clabs::file::sperms'),

  # Recursion
  $recurse  = false,
  $purge    = false,
  $ignore   = hiera('clabs::file::ignore'),

  # Internal Use
  $cmodname = undef,
) {

  # Source may be different than the target
  $target = $source ? {
    undef   => $name,
    default => $source,
  }

  # Get the caller module
  $caller = $cmodname ? {
    undef   => $caller_module_name, # Use current scope
    default => $cmodname,           # Use override
  }

  file {
    "${drive}${name}":
      replace => $replace,
      force   => $force,

      # Targetting
      content => $content,
      source  => $content ? {
        undef => [
            "puppet:///modules/${caller}/${target}-${::hostname}",
            "puppet:///modules/${caller}/${target}-${::operatingsystem}",
            "puppet:///modules/${caller}/${target}-${::env}",
            "puppet:///modules/${caller}/${target}-${::env}-${::operatingsystem}",
            "puppet:///modules/${caller}/${target}",
          ],
        default => undef,
      },

      # Permissions
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      source_permissions => $sperms,

      # Recursion
      purge   => $purge,
      recurse => $recurse,
      ignore  => $ignore,
  }


}

