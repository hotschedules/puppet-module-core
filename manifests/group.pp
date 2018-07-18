# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Define: clabs::group
# ---
#
# Operating System Group Management
#
# A wrapper around the {Puppet Group Resource}[https://docs.puppet.com/puppet/latest/reference/type.html#group] 
# for managing operating system groups.
#
# === Parameters
# ---
#
# [*name*]
# - Default - NONE (REQUIRED)
# - {Puppet User Reference}[https://docs.puppet.com/puppet/latest/reference/type.html#group-attribute-name]
#
# [*ensure*]
# - Default - NONE (REQUIRED)
# - {Puppet User Reference}[https://docs.puppet.com/puppet/latest/reference/type.html#group-attribute-ensure]
#
# [*auth_membership*]
# - Default - NONE (REQUIRED)
# - {Puppet User Reference}[https://docs.puppet.com/puppet/latest/reference/type.html#group-attribute-auth_membership]
#
# [*gid*]
# - Default - undef
# - {Puppet User Reference}[https://docs.puppet.com/puppet/latest/reference/type.html#group-attribute-gid]
#
# [*members*]
# - Default - undef
# - {Puppet User Reference}[https://docs.puppet.com/puppet/latest/reference/type.html#group-attribute-members]
#
# [*system*]
# - Default - NONE (REQUIRED)
# - {Puppet User Reference}[https://docs.puppet.com/puppet/latest/reference/type.html#group-attribute-system]

define clabs::group(
  $ensure,
  $auth_membership  = undef,
  $gid              = undef,
  $members          = undef,
  $system           = undef,
) {

  $settings = {
    ensure          => $ensure,
    auth_membership => $auth_membership,
    gid             => $gid,
    members         => $members,
    system          => $system,
  }

  ensure_resource('group', $name, $settings)

}


