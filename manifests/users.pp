# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# Create local user accounts from hiera data
#
class clabs::users {

  $accounts = hiera_hash('clabs::users::accounts', [])
  $defaults = hiera_hash('clabs::users::defaults')

  # Create Local Users
  if ! empty($accounts) {
    create_resources('clabs::user', $accounts, $defaults)
  }

}

