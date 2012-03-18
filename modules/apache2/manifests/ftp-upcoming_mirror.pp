class apache2::ftp-upcoming_mirror {
    include apache2
    file {
        "/etc/apache2/sites-available/ftp-upcoming.debian.org":
            source  => [ "puppet:///modules/apache2/per-host/$fqdn/etc/apache2/sites-available/ftp-upcoming.debian.org",
                         "puppet:///modules/apache2/common/etc/apache2/sites-available/ftp-upcoming.debian.org" ];

    }

    activate_apache_site {
        "010-ftp-upcoming.debian.org": site => "ftp-upcoming.debian.org";
    }

}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
