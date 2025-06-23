# extensions to Puppetlab's apache module.
# Class to manage php installation & config for apache
# the mod_php module is removed from apache in >= rhel9
# so we need to use php-fpm instead.
class apache_ext::php_fpm {
  package { "php-fpm":
    ensure  => $ensure,
    require => Package['httpd'],
    notify  => Class['apache::service'],
  }

  require '::apache::mod::proxy_fcgi'

  file { "php_fpm.conf":
    ensure  => file,
    path    => "${apache::mod_dir}/${name}",
    owner   => 'root',
    group   => $root_group,
    mode    => $apache::file_mode,
    source => "puppet:///modules/apache_ext/${name}",
    notify  => Class['apache::service'],
  }

}
