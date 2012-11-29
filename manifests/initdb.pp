# puppet-postgresql
# For all details and documentation:
# http://github.com/inkling/puppet-postgresql
#
# Copyright 2012- Inkling Systems, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class postgresql::initdb(
  $datadir     = '',
  $encoding    = 'UTF8',
  $group       = 'postgres',
  $initdb_path = '',
  $options     = '',
  $user        = 'postgres'
) inherits postgresql::params {


  if ! $datadir {
    include postgresql::paths
    $datadir_real = $postgresql::paths::datadir
  }
  else {
    $datadir_real = $datadir
  }
  
  if ! $initdb_path {
    include postgresql::paths
    $initdb_path_real = $postgresql::paths::initdb_path
  }
  else {
    $initdb_path_real = $initdb_path
  }
  
  
  exec { "${initdb_path_real} --encoding '${encoding}' --pgdata '${datadir_real}'":
    creates => "${datadir_real}/PG_VERSION",
    user    => $user,
    group   => $group,
    require => Package['postgresql-server'],
  }
}
