# Create a dashboard
define gdash::dashboard(
    $category = 'servers',
    $description = '',
    $graph_properties = {}
) {
    Gdash::Category[$category] -> Gdash::Dashboard[$title]

    $dashboard_dir = "${gdash::configure::template_dir}/${category}/${title}"

    file { $dashboard_dir:
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    file { "${dashboard_dir}/dash.yaml":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template( 'gdash/dash.yaml.erb' ),
        require => File[$dashboard_dir],
    }
}
