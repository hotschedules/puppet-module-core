# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker
#
# == Define: clabs::user
# ---
#
# Operating System User Account Management
#
# A wrapper around the {Puppet User Resource}[http://docs.puppetlabs.com/references/stable/type.html#user] for managing operating system user accounts.
#
# === Parameters
# ---
#
# [*name*]
# - Default - NONE (REQUIRED)
# - {Puppet User Reference}[http://docs.puppetlabs.com/references/stable/type.html#user-attribute-name]
#
# [*ensure*]
# - Default - NONE (REQUIRED)
# - {Puppet User Reference}[http://docs.puppetlabs.com/references/stable/type.html#user-attribute-ensure]
#
# [*groups*]
# - Default - NONE (OPTIONAL)
# - {Puppet User Reference}[http://docs.puppetlabs.com/references/stable/type.html#user-attribute-groups]
#
# [*password*]
# - Default - NONE (REQUIRED)
# - {Puppet User Reference}[http://docs.puppetlabs.com/references/stable/type.html#user-attribute-password]
#
# [*comment*]
# - Default - NONE (REQUIRED)
# - {Puppet User Reference}[http://docs.puppetlabs.com/references/stable/type.html#user-attribute-comment]
#
# [*managehome*]
# - Default - NONE (REQUIRED)
# - {Puppet User Reference}[http://docs.puppetlabs.com/references/stable/type.html#user-attribute-managehome]
#
# [*system*]
# - Default - NONE (REQUIRED)
# - {Puppet User Reference}[http://docs.puppetlabs.com/references/stable/type.html#user-attribute-system]
#
# [*uid*]
# - Default - undef
# - {Puppet User Reference}[http://docs.puppetlabs.com/references/stable/type.html#user-attribute-uid]
#
# [*gid*]
# - Default - undef
# - {Puppet User Reference}[http://docs.puppetlabs.com/references/stable/type.html#user-attribute-gid]
#
# [*shell*]
# - Default - undef
# - {Puppet User Reference}[http://docs.puppetlabs.com/references/stable/type.html#user-attribute-shell]
#
# [*home*]
# - Default - undef
# - {Puppet User Reference}[http://docs.puppetlabs.com/references/stable/type.html#user-attribute-home]
#
# [*sshauthkeys*]
# - Default - undef
# - sshauthkeys [
#     - 'SSH PUBLIC KEY DATA...'
#     - 'SSH PUBLIC KEY DATA 2..'
#   ]
# - { Puppet ssh_authorized_key Type Reference}[http://docs.puppetlabs.com/references/stable/type.html#ssh_authorized_key-attribute-type]
# - { Puppet ssh_authorized_key Key Reference}[http://docs.puppetlabs.com/references/stable/type.html#ssh_authorized_key-attribute-key]
#
# [*sshconfig*]
# - Default - undef
# - String containing a config file for ssh
# - Modifies $home/.ssh/config
#
# [*sshkeys*]
# - Default - undef
# - SSH Key Hash  {
#    keyname        => 'keyfile-name (id_rsa) ' {
#       private     => 'SSH PRIVATE KEY DATA...'
#       public      => 'SSH PUBLIC KEY DATA...'
#       ensurekey   =>  'present'
#     }
#   }
#
define clabs::user(
  $ensure,
  $password,
  $comment,
  $managehome,
  $system,
  $groups       = undef,
  $uid          = undef,
  $gid          = undef,
  $shell        = undef,
  $home         = $::kernel ? {
    'Linux' => "/home/${name}",
    default => undef,
  },
  $ssh          = undef,
  $sshauthkeys  = undef,
  $sshconfig    = undef,
  $sshkeys      = undef,
  $forcelocal   = false,
) {

  $settings = {
    ensure      => $ensure,
    groups      => $groups,
    password    => $password,
    comment     => $comment,
    managehome  => $managehome,
    system      => $system,
    uid         => $uid,
    gid         => $gid,
    shell       => $shell,
    home        => $home,
    forcelocal  => $forcelocal,
  }


  # useradd will create a group matching the username by default on Linux
  $defgroup = $gid ? {
    undef   => $name,
    default => $gid,
  }

  ensure_resource('user', $name, $settings)

  $deps = User[$name]

  file { "${home}/.ssh":
    ensure      => directory,
    owner       => $name,
    group       => $defgroup,
    require     => $deps,
    mode        => '0700',
  }

  # SSH Key Management
  if $sshkeys {
    validate_hash($sshkeys)
    create_resources(clabs::user::sshkeys, $sshkeys, { 
      'group'   => $defgroup,
      'home'    => $home,
      'require' => $deps,
      'user'    => $name,
    }) 
  }

  # FIXME: will generate resource conflicts if the same key is authorized
  #   to different accounts.
  #
  if $sshauthkeys {
    validate_array($sshauthkeys)

    clabs::user::sshauthkey { $sshauthkeys:
      user      => $name,
      require   => $deps,
    }
  }
  
  # Manage user SSH Configurations
  # Modifies: $home/.ssh/config
  if $sshconfig {
    validate_string($sshconfig)

    file { "${home}/.ssh/config":
      owner     => $name,
      ensure    => $ensure,
      group     => $defgroup,
      mode      => '0400',
      require   => $deps,
      content   => $sshconfig,
    }
  }
}

define clabs::user::sshkeys(
  $group,
  $home,
  $keyfname   = $name,
  $private    = undef,
  $public     = undef,
  $user,
  $ensure     = undef,
) {

  $defensure = $ensure ? {
    undef   => 'present',
    default =>  $ensure
  }

  validate_string($group)
  validate_string($home)
  validate_string($keyfname)
  validate_string($user)
 
  # Process public and private keys, or send a debugging error
  if $private {

    validate_string($private)
    file { "${home}/.ssh/${keyfname}":
      content => $private,
      group   => $group,
      mode    => '0400',
      ensure  => $defensure,
      require => $deps,
      owner   => $user,
    } 
  }

  if $public {
    validate_string($public)

    file { "${home}/.ssh/${keyfname}.pub":
      content => $public,
      group   => $group,
      mode    => '0400',
      ensure  => $defensure,
      require => $deps,
      owner   => $user,
    }
  }

  if ! $private and ! $public {
    notify { $name:
      withpath => true,
      name     => 'WARN: my existance is pointless without public or private ssh keys',
      loglevel =>  'warn'
    }
  }
}

define clabs::user::sshauthkey(

  $user,                  # Target User
  $ensure = 'present',

) {

  validate_string($user)

  validate_re($name, '^(ssh-rsa|ssh-dss)')

  $type = $name ? {
    /^ssh-rsa/  => 'ssh-rsa',
    /^ssh-dss/  => 'ssh-dsa',
    default     => undef,
  }

  validate_string($type)

  # Extract key
  $keydata = regsubst($name, '^(ssh-rsa|ssh-dss) ', '')

  # Generate a unique resource ID (must NOT contain spaces!)
  $unique = md5("${user}-authkey-${name}")

  ssh_authorized_key {
    $unique:
      ensure    => $ensure,
      user      => $user,
      type      => $type,
      key       => $keydata,
  }
}
