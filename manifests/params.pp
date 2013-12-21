# Class: apache::params
#
# This class manages Apache parameters
#
# Parameters:
# - The $user that Apache runs as
# - The $group that Apache runs as
# - The $apache_name is the name of the package and service on the relevant
#   distribution
# - The $php_package is the name of the package that provided PHP
# - The $ssl_package is the name of the Apache SSL package
# - The $apache_dev is the name of the Apache development libraries package
# - The $conf_contents is the contents of the Apache configuration file
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class gdash::params {
    $graphite_host  = '127.0.0.1',
    $gdash_root     = '/usr/local/gdash',
}
