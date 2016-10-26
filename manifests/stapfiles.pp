# == Define: systemtap::stapfiles
#
define systemtap::stapfiles (
  $ensure = 'present',
){

  include ::systemtap

  file { "/root/systemtap/${name}.ko":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    source  => "puppet:///modules/systemtap/${name}.ko",
    require => File['/root/systemtap'],
  }

  exec { "load-stapfile-${name}":
    command => "/usr/bin/staprun -L /root/systemtap/${name}.ko",
    unless  => "/bin/grep -q ${name} /proc/modules",
    require => [Package['systemtap-runtime'], File["/root/systemtap/${name}.ko"]],
  }
}

