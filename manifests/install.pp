# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Define: clabs::install
# ---
#
# Operating System Package Install
#
# A wrapper around the {Puppet Package Resource}[http://docs.puppetlabs.com/references/stable/type.html#package] for installing an operating system package.
#
# === Parameters
# ---
#
# [*provider*]
# - Default - (Hiera: *clabs::install::provider*) or undef (OS Default)
# - {Puppet Package Reference}[http://docs.puppetlabs.com/references/stable/type.html#package-attribute-provider]
#
# [*ensure*]
# - Default - installed
# - {Puppet Package Reference}[http://docs.puppetlabs.com/references/stable/type.html#package-attribute-ensure]
#
# [*require*]
# - Default - UNDEF (OPTIONAL)
# - Resource Dependency
#
# [*source*]
# - Default - UNDEF (OPTIONAL)
# - {Puppet Package Reference}[http://docs.puppetlabs.com/references/stable/type.html#package-attribute-source]
#
#
define clabs::install(

  $provider = hiera('clabs::install::provider', undef),
  $ensure   = 'installed',
  $require  = undef,
  $source   = undef,

) {

  Package {
    provider  => $provider,
    ensure    => $ensure,
    require   => $require,
    source    => $source,
  }

  if ! is_array($name) {
    ensure_packages([$name])
  } else {
    ensure_packages($name)
  }

}
