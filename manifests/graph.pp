# Create a graph
define gdash::graph(
    $graph_title = $title,
    $vtitle = '',
    $description = '',
    $area = 'none',
    $category = 'servers',
    $dashboard = $hostname,
    $ymin = undef,
    $ymax = undef
) {
    Gdash::Dashboard[$dashboard] -> Gdash::Graph[$title]

    $graph_file = "${gdash::configure::template_dir}/${category}/${dashboard}/${title}.graph"

    datacat { $graph_file:
        template    => 'gdash/graph.erb',
    }

    datacat_fragment { "${category}_${title}":
        target      => $graph_file,
        loglevel    => 'debug',
        data        => {
            area        => $area,
            ymax        => $ymax,
            ymin        => $ymin,
            alpha       => $alpha,
            vtitle      => $vtitle,
            graph_title => $graph_title,
            description => $description,
        },
    }
}
