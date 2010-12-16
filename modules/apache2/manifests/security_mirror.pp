class apache2::security_mirror inherits apache2 {
    file {
        "/etc/apache2/sites-available/security.debian.org":
            source  => [ "puppet:///modules/apache2/per-host/$fqdn/etc/apache2/sites-available/security.debian.org",
                         "puppet:///modules/apache2/common/etc/apache2/sites-available/security.debian.org" ];

    }

    activate_apache_site {
        "010-security.debian.org": site => "security.debian.org";
        "security.debian.org": ensure => absent;
    }

}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
