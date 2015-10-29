# Alert Logic Debian al-agent Puppet Manifest
# Installs and provisions Alert Logic al-agent package
#
# Author: Justin Early <jearly@alertlogic.com>
#

# Download and install al-agent package
define url_package (
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
    name     => $package,
    provider => 'dpkg',
    source   => $package_path,
  }

  file {'cleanup':
    ensure => absent,
    path   => $package_path,
  }

  Exec['download'] -> Package['install'] -> File['cleanup']

}

# Configure Alert Logic agent 
define configure_agent (
  $configure_cmd,
) {
  exec {'configure':
    command => $configure_cmd
  }
}

# Provision Alert Logic agent 
define provision_agent (
  $registration_key
) {
  exec {'provision':
    command => "/etc/init.d/al-agent provision \
      --key ${registration_key} \
      --inst-type host"
  }
}

# Start Alert Logic agent 
define start_agent () {
  service { 'al-agent':
    ensure => 'running',
  }
}

# Determine architecture and define package url
if $architecture == 'amd64' {
  $pkg_url = 'https://scc.alertlogic.net/software/al-agent_LATEST_amd64.deb'
}
elsif $architecture == 'i386' {
  $pkg_url = 'https://scc.alertlogic.net/software/al-agent_LATEST_i386.deb'
}
else {
  crit('Cannot reasonably determine the system architecture.')
}

# User defined settings
# $egress_url: Defaults to vaportator.alertlogic.com:443
# $agent_proxy: defaults to undefined. Can be set if you want to 
# send traffic through SOCKS or HTTP proxy

# Alert Logic primary Egress URL. 
$egress_url = 'vaporator.alertlogic.com:443'

# HTTP or SOCKS proxy. Defaults to undef
$agent_proxy = undef

# Alert Logic Unique Registration Key
$registration_key = 'your_registration_key_here'

# Check if $proxy_url is set and configure with SOCK or HTTP proxy if defined.
if $agent_proxy == undef {
  $configure = "/etc/init.d/al-agent configure --host ${egress_url}"
}
else {
  $configure = "/etc/init.d/al-agent configure \
    --host ${egress_url} \
    --proxy ${agent_proxy}"
}

# This manifest defaults to all nodes. To specify specific hosts, 
# change 'default' below to 'node-name' for each node you want to apply 
# this manifest to separated by commas.
node default {
  url_package {'al-agent':
    url      => $pkg_url,
    provider => 'dpkg',
  }
  configure_agent {'al-agent':
    configure_cmd => $configure
  }
  provision_agent {'al-agent':
    registration_key => $registration_key
  }
  start_agent {'al-agent':}
}
