class apache_ext::php::ldap {
  ::apache_ext::php::ext { 'ldap':
    require => Class['::apache_ext::php_fpm'],
  }
}