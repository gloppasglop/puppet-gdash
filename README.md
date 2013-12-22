#gdash

[![Build Status](https://travis-ci.org/bfraser/puppet-gdash.png?branch=master)](https://travis-ci.org/bfraser/puppet-gdash)

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Beginning with GDash](#beginning-with-gdash)
4. [Implementation](#implementation)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Defined Type: gdash::category](#defined-type-gdashcategory)
        * [Defined Type: gdash::dashboard](#defined-type-gdashdashboard)
        * [Defined Type: gdash::graph](#defined-type-gdashgraph)
        * [Defined Type: gdash::field](#defined-type-gdashfield)
    * [Templates](#templates)
5. [Limitations](#limitations)
6. [Copyright and License](#copyright-and-license)

##Overview

This module installs GDash and enables creation of dashboards using manifests.

##Module Description

GDash is a dashboard for Graphite, therefore it is assumed you have a Graphite installation GDash will be pulling data from. This module does **not** manage Graphite in any way.

##Setup

This module assumes that you will be serving GDash using a Rails server such as Passenger. It will:

* Install all required Ruby gems
* Clone the GDash Git repository
* Create a default dashboard configured to use your Graphite server
* Provide a framework for you to declare graphs and fields in your manifests

Add the following to your manifest to create an Apache virtual host to serve GDash using Passenger. **NOTE** This requires the puppetlabs-apache module.

```puppet
    # Enable Apache modules
    class { "apache::mod::headers": }
    class { "apache::mod::passenger":
        passenger_high_performance  => "On",
        passenger_pool_idle_time    => 600,
        passenger_max_requests      => 1000,
        passenger_root              => $apache::params::passenger_root,
        passenger_ruby              => $apache::params::passenger_ruby,
        passenger_max_pool_size     => 12,
    }

    # Create Apache virtual host
    apache::vhost { "gdash.example.com":
        servername      => "gdash.example.com",
        port            => "9292",
        docroot         => "/usr/local/gdash/public",
        error_log_file  => "gdash-error.log",
        access_log_file => "gdash-access.log",
        directories     => [
            {
                path            => "/usr/local/gdash/",
                options         => [ "None" ],
                allow           => "from All",
                allow_override  => [ "None" ],
                order           => "Allow,Deny",
            }
        ]
    }
```

###Beginning with GDash

To install GDash with the default parameters:

```puppet
    class { 'gdash': }
```

This assumes that you have Graphite running on the same server as GDash, and that you want to install GDash to /usr/local/gdash. To establish customized parameters:

```puppet
    class { 'gdash':
      graphite_host     => 'graphite.example.com',
      gdash_root        => '/opt/gdash',
    }
```

##Implementation

###Classes and Defined Types

####Defined Type: `gdash::category`

Creates a category for your dashboard(s) to be grouped into.

```puppet
    gdash::category { "gdash": }
```

####Defined Type: `gdash::dashboard`

Creates a dashboard for your graphs to be organized under.

```puppet
    gdash::dashboard { "gdash":
        name        => "GDash",
        description => "GDash Server",
        category    => "gdash",
        require     => Gdash::Category["gdash"],
    }
```

####Defined Type: `gdash::graph`

Creates a graph in a dashboard.

```puppet
    gdash::graph { "gdash_cpu_usage":
        name        => "GDash CPU Usage",
        vtitle      => "percent",
        area        => "none",
        ymin        => 0,
        ymax        => 100,
        description => "CPU Usage for the GDash server",
        dashboard   => "gdash",
        category    => "gdash",
        require     => Gdash::Dashboard["gdash"],
    }
```

####Defined Type: `gdash::field`

Adds a field to a graph.

```puppet
        gdash::field { "${hostname}_cpu_user":
        scale       => 1,
        graph       => "gdash_cpu_usage",
        color       => "yellow",
        alias       => "$hostname User",
        data        => "sumSeries(servers.${hostname}.cpu.total.user)",
        category    => "gdash",
        require     => Gdash::Graph["gdash_cpu_usage"],
    }
```

###Templates

This module currently makes use of three templates: one containing the configuration for GDash's main dashboard; one used to create custom dashboard; and one to create graphs.

##Limitations

This module has been tested on CentOS 6.4 with Apache and Passenger. Other configurations should work with minimal effort, as only package names may change.

##Copyright and License

Copyright (C) 2013 Bill Fraser

Bill can be contacted at: fraser@pythian.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
