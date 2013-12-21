define gdash::field(
    $scale = 1,
    $category = "servers",
    $dashboard = $hostname,
    $color = undef,
    $legend_alias = $title,
    $graph,
    $data
) {
    Gdash::Graph[$graph] -> Gdash::Field[$title]

    datacat_fragment { "${category}_${graph}_${title}":
        target      => "${gdash::configure::template_dir}/${category}/${dashboard}/${graph}.graph",
        loglevel    => "debug",
        data        => {
            fields  => [
                {
                    name    => $title,
                    scale   => $scale,
                    color   => $color,
                    alias   => $legend_alias,
                    data    => $data,
                }
            ],
        },
    }
}
