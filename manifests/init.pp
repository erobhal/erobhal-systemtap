# == Class: systemtap
#
# Full description of class systemtap here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { systemtap:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class systemtap {


  case $::osfamily {
    'RedHat': {
      case $::operatingsystemrelease {
        '6.4': {
          $stapfiles = {
            'stap_11b46466687403f5b1d22fc2fba37380_64592' => { 'ensure' => 'present' },
          }
        }
        '6.6': {
          $stapfiles = {
            'stap_5afe0a813b16d0017d1b502a89afe606_64586' => { 'ensure' => 'present' },
          }
        }
        default: {
          fail("systemtap supports RedHat 6.4 and 6.6. Detected RedHat release is ${::operatingsystemrelease}.")
        }
      }
    }
    default: {
      fail("systemtap supports osfamilies RedHat. Detected osfamily is ${::osfamily}.")
    }
  }


  package {'systemtap-runtime':
    ensure => 'present',
  }

  file {'/root/systemtap':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }


  create_resources('systemtap::stapfiles',$stapfiles)

}
