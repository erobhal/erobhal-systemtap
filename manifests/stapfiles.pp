# == Define: systemtap::stapfiles
#
define systemtap::stapfiles (
  $stap,
  $ensure = 'present',
){

  include ::systemtap

  validate_re($ensure,'^(present)|(absent)$',
    "systemtap::stapfiles::${name}::ensure must be 'present' or 'absent'. Detected value is '${ensure}'.")

  

  file { "/root/systemtap/${stap}.ko":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    source  => "puppet:///modules/systemtap/${stap}.ko",
    require => File['/root/systemtap'],
  }

  if $ensure == 'present' {
    exec { "load-stapfile-${name}":
      command => "/usr/bin/staprun -L /root/systemtap/${stap}.ko",
      unless  => "/bin/grep -q ${stap} /proc/modules",
      require => [Package['systemtap-runtime'], File["/root/systemtap/${stap}.ko"]],
    }
  } else {
    exec { "load-stapfile-${name}":
      command => "/usr/bin/staprun -d ${stap}",
      onlyif  => "/bin/grep -q ${stap} /proc/modules",
      require => Package['systemtap-runtime'],
    }
  }

}

