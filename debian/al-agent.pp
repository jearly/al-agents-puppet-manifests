# Alert Logic Debian al-agent Puppet Manifest
# Installs and provisions Alert Logic al-agent package
#
# Author: Justin Early <jearly@alertlogic.com>
#

define url-package (
  $url,
  $provider,
  $package = undef,
) {

  if $package {
    $package_real = $package
  } else {
    $package_real = $title
  }

  $package_path = "/tmp/${package_real}"

  exec {'download':
    command => "/usr/bin/wget -O ${package_path} ${url}"
  }

  package {'install':
    ensure   => installed,
    name     => "${package}",
    provider => 'dpkg',
    source   => "${package_path}",
  }

  file {'cleanup':
    ensure => absent,
    path   => "${package_path}",
  }

  Exec['download'] -> Package['install'] -> File['cleanup']

}

define configure-agent (
  $configure_cmd,
) {
  exec {'configure':
    command => $configure_cmd
  }
}

define provision-agent (
  $registration_key
) {
  exec {'provision':
    command => "/etc/init.d/al-agent provision --key ${registration_key} --inst-type host"
  }
}

# Determine architecture and define package url
if $architecture == 'amd64' {
  $pkg_url = "http://ns1.pd.alertlogic.net/unified/agents/package/Linux-amd64-libc6_2.7-TEST/al-agent_2.1.2+rc1.dev.TEST_amd64.deb"
}
elsif $architecture == 'i386' {
  $pkg_url = "http://ns1.pd.alertlogic.net/unified/agents/package/Linux-i386-libc6_2.7-TEST/al-agent_2.1.2+rc1.dev.TEST_i386.deb"
}
else {
  crit('Cannot reasonably determine the system architecture.')
}

$egress_url = "vaporator.alertlogic.com:443"
$agent_proxy = undef

if $agent_proxy == undef {
  $configure = "/etc/init.d/al-agent configure --host ${egress_url}"
}
else {
  $configure = "/etc/init.d/al-agent configure --host ${egress_url} --proxy ${agent_proxy}"
}

node 'node' {
  url-package {'al-agent':
    url      => $pkg_url,
    provider => 'dpkg',
  }
  configure-agent {'al-agent':
    configure_cmd => $configure
  }
  provision-agent {'al-agent':
    registration_key => 'your_registration_key_here'
  }
}
