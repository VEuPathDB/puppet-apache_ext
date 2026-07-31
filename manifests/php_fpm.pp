# extensions to Puppetlab's apache module.
# Class to manage php installation & config for apache
# the mod_php module is removed from apache in >= rhel9
# so we need to use php-fpm instead.
class apache_ext::php_fpm {
  package { "php-fpm":
    ensure  => installed,
    require => Package['httpd'],
    notify  => Class['apache::service'],
  }

  require '::apache::mod::proxy_fcgi'

  file { "php_fpm.conf":
    ensure  => file,
    path    => "${apache::mod_dir}/php_fpm.conf",
    owner   => 'root',
    group   =>  $apache::params::group,
    mode    => $apache::file_mode,
    source => "puppet:///modules/apache_ext/php_fpm.conf",
    notify  => Class['apache::service'],
  }

  file { "/var/log/php-fpm":
    ensure => directory,
    mode => "775",
    owner => 'apache',
    require => Package['php-fpm'],
  }

}
