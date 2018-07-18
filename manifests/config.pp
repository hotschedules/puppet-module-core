# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# General Configuration File
#
# Documentation: http://docs.puppetlabs.com/references/stable/type.html#file
#
define clabs::config(
  # Targetting
  $replace  = true,
  $force    = false,
  $content  = undef,
  $source   = undef,
  $drive    = hiera('clabs::config::drive'),

  # Permissions
  $seltype  = undef,
  $owner    = hiera('clabs::config::owner'),
  $group    = hiera('clabs::config::group'),
  $mode     = hiera('clabs::config::mode'),
  $sperms   = hiera('clabs::config::sperms'),

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
#
