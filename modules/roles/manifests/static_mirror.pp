class roles::static_mirror inherits roles::static_source {
    include apache2

    package { 'libapache2-mod-macro':
        ensure => installed,
    }

    apache2::module { 'macro': require => Package['libapache2-mod-macro']; }
    apache2::module { 'rewrite': }
    apache2::module { 'expires': }

    file {
        '/usr/local/bin/static-mirror-run':
            source  => "puppet:///modules/roles/static-mirroring/static-mirror-run",
            mode => 555,
            ;

        "/srv/static.debian.org":
            ensure  => directory,
            owner   => staticsync,
            group   => staticsync,
            mode    => '02755'
            ;
        "/etc/cron.d/puppet-static-mirror":
            content => "PATH=/usr/local/bin:/usr/bin:/bin\n@reboot staticsync sleep 60; static-mirror-run --one-stage /srv/static.debian.org bizet.debian.org:-live- > /dev/null\n",
            ;
    }

    $vhost_listen = $::hostname ? {
        klecker => '130.89.148.14:80 [2001:610:1908:b000::148:14]:80',
        default => '*:80',
    }

    apache2::site { '010-planet.debian.org':
        site   => 'planet.debian.org',
        content => 'puppet:///modules/roles/static-mirroring/vhost/planet.debian.org.erb',
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
