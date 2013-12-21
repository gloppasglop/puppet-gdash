# Create a directory to contain your dashboard
define gdash::category() {
    Class['gdash::configure'] -> Gdash::Category[$title]

    file { "${gdash::configure::template_dir}/${title}":
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }
}
