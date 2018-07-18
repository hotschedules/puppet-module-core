# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# Create local user groups from hiera data
#
class clabs::groups {

  $_groups = hiera_hash('clabs::groups')

  # Create Local Users
  if ! empty($_groups) {
    create_resources('clabs::group', $_groups)
  }

}

