# Class: postgresql::server
#
# == Class: postgresql::server
# Manages the installation of the postgresql server.  manages the package and
# service.
#
# === Parameters:
# [*package_name*] - name of package
# [*service_name*] - name of service
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql::server (
  $package_name     = '',
  $package_ensure   = 'present',
  $service_provider = $postgresql::params::service_provider,
  $service_status   = $postgresql::params::service_status,
  $config_hash      = {}
) inherits postgresql::params {

  require postgresql
  include postgresql::paths

  if ! $package_name {
    include postgresql::packages
    $package_name_real = $postgresql::packages::server_package_name
  }
  else {
    $package_name_real = $package_name
  }

  package { 'postgresql-server':
    ensure  => $package_ensure,
    name    => $package_name_real,
  }
  
  $config_class = {}
  $config_class['postgresql::config'] = $config_hash

  create_resources( 'class', $config_class )
  

  service { 'postgresqld':
    ensure   => running,
    name     => $postgresql::paths::service_name,
    enable   => true,
    require  => Package['postgresql-server'],
    provider => $service_provider,
    status   => $service_status,
  }
  
  if ($postgresql::params::needs_initdb) {
    include postgresql::initdb

    Package['postgresql-server'] -> Class['postgresql::initdb'] -> Class['postgresql::config'] -> Service['postgresqld']
  } 
  else  {
    Package['postgresql-server'] -> Class['postgresql::config'] -> Service['postgresqld']
  }


}
