class roles::static_mirror inherits roles::static_base {
    file {
        '/etc/ssh/userkeys/staticsync':
            content => template('roles/static-mirror-authorized_keys.erb'),
            ;
        '/usr/local/bin/static-mirror-run':
            source  => "puppet:///modules/roles/static-mirroring/static-mirror-run",
            mode => 555,
            ;
        '/usr/local/bin/static-mirror-ssh-wrap':
            source  => "puppet:///modules/roles/static-mirroring/static-mirror-ssh-wrap",
            mode => 555,
            ;
    }

    file {
        "/srv/static.debian.org":
            ensure  => directory,
            owner   => staticsync,
            group   => staticsync,
            mode    => '02755'
            ;
        "/etc/cron.d/puppet-static-mirror":
            content => "PATH=/usr/local/bin:/usr/bin:/bin\n@reboot staticsync sleep 60; static-mirror-run --one-stage /srv/static.debian.org bizet.debian.org:-live- > /dev/null\n",
            ;

        #"/etc/apache2/sites-available/dist.torproject.org":
        #    source  => "puppet:///modules/roles/static-mirroring/vhost/dist.torproject.org",
        #    require => Package["apache2"],
        #    notify  => Exec["reload-apache2"],
        #    ;
        #"/etc/apache2/sites-available/www.torproject.org":
        #    source  => "puppet:///modules/roles/static-mirroring/vhost/www.torproject.org",
        #    require => Package["apache2"],
        #    notify  => Exec["reload-apache2"],
        #    ;
    }

    #apache2::activate_apache_site {
    #    "10-dist.torproject.org":
    #        site => "dist.torproject.org",
    #        require => File['/etc/ssl/certs/apache-wildcard.torproject.org.pem'];
    #    "10-www.torproject.org":
    #        site => "www.torproject.org",
    #        require => File['/etc/ssl/certs/apache-wildcard.torproject.org.pem'];
    #}
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
