# manage mod_jk for puppetlabs-apache 1.x
# This will be managed by puppetlabs-apache 2.x                             
class apache_ext::mod::jk (
  $jkworkersfile = '/etc/httpd/conf/workers.properties',
  $jklogfile     = '/var/log/httpd/mod_jk.log',
  $jkshmfile     = '/var/cache/httpd/mod_jk/jk.shm',
  $jkloglevel    = 'warning',
) {
  apache::mod { 'jk':
    package => 'mod_jk',
  }

  file { 'jk.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/jk.conf",
    content => template('apache_ext/mod/jk.conf.erb'),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
