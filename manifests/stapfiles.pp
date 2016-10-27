# == Define: systemtap::stapfiles
#
define systemtap::stapfiles (
  $ensure = 'present',
){

  include ::systemtap

  validate_re($ensure,'^(present)|(absent)$',
    "systemtap::stapfiles::${name}::ensure must be 'present' or 'absent'. Detected value is '${ensure}'.")

  

  file { "/root/systemtap/${name}.ko":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    source  => "puppet:///modules/systemtap/${name}.ko",
    require => File['/root/systemtap'],
  }

  if $ensure == 'present' {
    exec { "load-stapfile-${name}":
      command => "/usr/bin/staprun -L /root/systemtap/${name}.ko",
      unless  => "/bin/grep -q ${name} /proc/modules",
      require => [Package['systemtap-runtime'], File["/root/systemtap/${name}.ko"]],
    }
  } else {
    exec { "load-stapfile-${name}":
      command => "/usr/bin/staprun -d ${name}",
      onlyif  => "/bin/grep -q ${name} /proc/modules",
      require => Package['systemtap-runtime'],
    }
  }

}

