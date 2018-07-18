# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Define: clabs::template
# ---
#
# File System File Template
#
# A wrapper around the {Puppet File Resource}[http://docs.puppetlabs.com/references/stable/type.html#file] for managing file system files using ERB Templating.
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
# - Default - NONE (REQUIRED PARAM)
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-content]
#
# [*drive*]
# - Default (*Hiera*) - *clabs*::*template*::*drive*
# - Description:
#     Prepends a location to the file target. This provides support for
#     both Windows and Linux. The Linux default is '' since Linux does not have
#     the concept of drive locations. The Windows default is 'C:'.
#
# ==== Permissions
#
# [*owner*]
# - Default (*Hiera*) - *clabs*::*template*::*owner*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-owner]
#
# [*group*]
# - Default (*Hiera*) - *clabs*::*template*::*group*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-group]
#
# [*mode*]
# - Default (*Hiera*) - *clabs*::*template*::*mode*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-mode]
#
# [*sperms*]
# - Default - (*Hiera*) - *clabs*::*template*::*sperms*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-source_permissions]
#
# [*seltype*]
# - Default - *undef*
# - {Puppet File Reference}[http://docs.puppetlabs.com/references/stable/type.html#file-attribute-seltype]
#
#
# === Examples
# ---
define clabs::template(
  # Targetting
  $replace    = true,
  $force      = false,
  $content    = undef,
  $drive      = hiera('clabs::template::drive'),

  # Permissions
  $owner    = hiera('clabs::template::owner'),
  $group    = hiera('clabs::template::group'),
  $mode     = hiera('clabs::template::mode'),
  $sperms   = hiera('clabs::template::sperms'),
  $seltype  = undef,
) {

  if ! $content {
    $source = "${caller_module_name}/${name}.erb"
  } else {
    $source = $content
  }

  file {
    "${drive}${name}":

      # Targetting
      replace => $replace,
      force   => $force,
      content => template($source),

      # Permissions
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      source_permissions => $sperms,
  }

}

