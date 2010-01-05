class apache2::security_mirror inherits apache2 {
       file {
               "/etc/apache2/sites-available/security.debian.org":
                       source  => [ "puppet:///apache2/per-host/$fqdn/etc/apache2/sites-available/security.debian.org",
                                    "puppet:///apache2/common/etc/apache2/sites-available/security.debian.org" ];

       }

       activate_apache_site {
               "010-security.debian.org": site => "security.debian.org";
               "security.debian.org": ensure => absent;
       }

}

