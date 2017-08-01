# Class: easy_sysctl
class easy_sysctl {

  include stdlib

  # Populate using hiera_hash command as we want to merge data from multiple hiera configs
  $sysctl_remove = hiera_hash('sysctl::remove', {})
  $sysctl_persist = hiera_hash('sysctl::persist',{})
  $sysctl_active = hiera_hash('sysctl::active',{})

  # get a list of sysctl settings from each subgroup from hiera
  $hash_kernel_active = $sysctl_active[$facts[kernel]]
  $hash_osfamily_active = $sysctl_active[$facts[osfamily]]
  $hash_kernel_persist = $sysctl_persist[$facts[kernel]]
  $hash_osfamily_persist = $sysctl_persist[$facts[osfamily]]
  $list_kernel_rm = $sysctl_remove[$facts[kernel]]
  $list_osfamily_rm =  $sysctl_remove[$facts[osfamily]]

  # Merge these hashs into one hash for each action
  #if $hash_osfamily_active {
    $hash_active = deep_merge($hash_kernel_active,$hash_osfamily_active)
    #} else {
    #$hash_active = $hash_kernel_active
    #}

    #if $hash_osfamily_persist {
    $hash_persist = deep_merge($hash_kernel_persist,$hash_osfamily_persist)
    #} else {
    #$hash_persist = $hash_kernel_persist
    #}

  if $list_osfamily_rm {
    $list_remove = any2array($list_kernel_rm) + any2array($list_osfamily_rm)
  } else {
    $list_remove = any2array($list_kernel_rm)
  }

  # Make sure we don't try to remove any we have tried to add
  $sysctl_to_remove = $list_remove - keys($hash_persist) - keys($hash_active)
  $sysctl_to_remove.each | $sysctl | {
    if $sysctl != '' {
      sysctl { $sysctl:
        ensure => absent,
      }
    }
  }

  $hash_persist.each | $sysctl, $value | {
    if $sysctl != '' {
      if $value =~ Array {
        sysctl { $sysctl:
          ensure  => present,
          value   => $value[0],
          comment => $value[1],
        }
      } else {
        sysctl { $sysctl:
          ensure => present,
          value  => $value,
        }
      }
    }
  }

  $hash_active.each | $sysctl, $value | {
    if $sysctl != '' {
      if $value =~ Array {
        sysctl { $sysctl:
          ensure  => present,
          value   => $value[0],
          comment => $value[1],
          persist => false,
        }
      } else {
        sysctl { $sysctl:
          ensure  => present,
          value   => $value,
          persist => false,
        }
      }
    }
  }



}
