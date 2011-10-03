class apache2::www_mirror inherits apache2 {
    file {
        "/etc/apache2/sites-available/www.debian.org":
            source  => [ "puppet:///modules/apache2/per-host/$fqdn/etc/apache2/sites-available/www.debian.org",
                         "puppet:///modules/apache2/common/etc/apache2/sites-available/www.debian.org" ],
            notify => Exec["reload-apache2"],
            ;
    }

    activate_apache_site {
        "010-www.debian.org": site => "www.debian.org";
        "www.debian.org": ensure => absent;
    }

}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
