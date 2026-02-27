# manage mod_brotli for puppetlabs-apache
# currently it's not doing much but load the module but we can extend this to add a conf file
# like the other modules if needed.
class apache_ext::mod::brotli (
) {
  apache::mod { 'brotli': }

}
