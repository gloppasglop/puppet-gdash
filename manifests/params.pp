# Class: gdash::params
#
# This class manages GDash parameters
#
# Parameters:
# - The $graphite_host for GDash to pull data from
# - The $gdash_root is the directory GDash is installed to
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class gdash::params {
    $graphite_host  = '127.0.0.1'
    $gdash_root     = '/usr/local/gdash'
    $gdash_source   = 'https://github.com/ripienaar/gdash.git'

    case $::osfamily {
       'Debian': {
           $ruby_dev_pkg =  'ruby-dev'
       }
       
       'Redhat': {
           $ruby_dev_pkg =  'ruby-devel'
       }
      default: {
         fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
      }
    }
}
