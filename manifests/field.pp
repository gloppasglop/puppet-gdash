# Add a field to your graph
define gdash::field(
    $graph,
    $data,
    $scale = 1,
    $category = 'servers',
    $dashboard = $hostname,
    $color = undef,
    $legend_alias = $title,
    $field_name = $title,
) {
    Gdash::Graph[$graph] -> Gdash::Field[$title]

    datacat_fragment { "${category}_${graph}_${title}":
        target      => "${gdash::configure::template_dir}/${category}/${dashboard}/${graph}.graph",
        loglevel    => 'debug',
        data        => {
            fields  => [
                {
                    name    => $field_name,
                    scale   => $scale,
                    color   => $color,
                    alias   => $legend_alias,
                    data    => $data,
                }
            ],
        },
    }
}
