class apache2::backports_mirror {
    include apache2
    file {
        "/etc/apache2/sites-available/backports.debian.org":
            source  => [ "puppet:///modules/apache2/per-host/$fqdn/etc/apache2/sites-available/backports.debian.org",
                         "puppet:///modules/apache2/common/etc/apache2/sites-available/backports.debian.org" ];
        "/etc/apache2/sites-available/www.backports.org":
            source  => [ "puppet:///modules/apache2/per-host/$fqdn/etc/apache2/sites-available/www.backports.org",
                         "puppet:///modules/apache2/common/etc/apache2/sites-available/www.backports.org" ];

    }

    activate_apache_site {
        "010-backports.debian.org": site => "backports.debian.org";
        "010-www.backports.org": site => "www.backports.org";
    }

    enable_module {
        "rewrite":;
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
