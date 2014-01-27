# == Class: gdash
#
# Full description of class gdash here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { gdash:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Bill Fraser <fraser@pythian.com>
#
# === Copyright
#
# Copyright 2013 Bill Fraser
#
class gdash (
    $graphite_host   = $gdash::params::graphite_host,
    $gdash_root      = $gdash::params::gdash_root,
    $gdash_source    = $gdash::param::gdash_source,
) inherits gdash::params {

    class { 'gdash::configure': }

    # Install necessary packages
    package { [ 'ruby-devel', 'git' ]:
        ensure      => present,
    }

    # Clone GDash Git repository
    vcsrepo { 'gdash':
        ensure          => present,
        path            => $gdash_root,
        provider        => 'git',
        source          => $gdash_source,
        require         => Package['git'],
    }

    # Install application dependencies using Bundler
    bundler::install { $gdash_root:
        user        => 'root',
        group       => 'root',
        deployment  => true,
        without     => 'development test doc',
        require     => [ Package['ruby-devel'], Vcsrepo['gdash'] ],
    }

    # Create config directory
    file { "${gdash_root}/config":
        ensure      => directory,
        require     => Vcsrepo['gdash'],
    }

    # Create default dashboard
    file { "${gdash_root}/config/gdash.yaml":
        content     => template('gdash/gdash.yaml.erb'),
        group       => 'root',
        owner       => 'root',
        require     => File["${gdash_root}/config"],
    }
}
