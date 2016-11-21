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
class systemtap (
  $cve_2016_5195 = 'absent',
) {

  case $::kernelrelease {
    '2.6.32-71.el6.x86_64': { # RHEL 6.1
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_4f1b2eb1f6f654eac8de0f6c6aa183b6_63732',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '2.6.32-131.0.15.el6.x86_64': { # RHEL 6.1
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_546d1641c0209a531d8a7c283913daf2_1148',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '2.6.32-358.el6.x86_64': { # RHEL 6.4
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_89f393d7e9627f70427a7955cebb8eab_64551',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '2.6.32-358.0.1.el6.x86_64': { # RHEL 6.4
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_1e59319eeadeba30a051d505c5457adb_22283',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '2.6.32-358.2.1.el6.x86_64': { # RHEL 6.4
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_309382b97d8362f2b078f1e66270feb1_21495',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '2.6.32-358.23.2.el6.x86_64': { # RHEL 6.4
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_593c4145315c60b518b60446b1a29ff8_64586',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '2.6.32-504.el6.x86_64': { # RHEL 6.6
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_ea6da5efcd139011b6206c1b14f18093_31885',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '2.6.32-504.30.3.el6.x86_64': { # RHEL 6.6
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_5afe0a813b16d0017d1b502a89afe606_64586',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '2.6.32-573.el6.x86_64': { # RHEL 6.7
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_2e89a675bef0aba035e0bd433d041918_54519',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '2.6.32-573.7.1.el6.x86_64': { # RHEL 6.7
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_c13876d03b289b03f837da7b3603d7f7_64585',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '3.10.0-229.14.1.el7.x86_64': { # RHEL 7.1
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_e192590f724d781714e1ee20c690ebcc_65629',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '3.10.0-327.4.4.el7.x86_64': { # RHEL 7.2
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_ca61092aebc514b9471a6a3e215ec768_65624',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    '3.10.0-327.28.2.el7.x86_64': { # RHEL 7.2
      $stapfiles = {
        'CVE-2016-5195' => {
          'stap'   => 'stap_802a3e229c22245e6df2d6ccb2064243_65631',
          'ensure' => $cve_2016_5195,
        },
      }
    }
    default: {
      $stapfiles = undef
      notify {"systemtap: no modules available for kernel ${::kernelrelease}.":}
    }
  }

  if $stapfiles != undef {

    unless has_key($stapfiles, 'CVE-2016-5195') {
      notify {"systemtap: module cve_2016_5195 not available for kernel ${::kernelrelease}.":}
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
}
