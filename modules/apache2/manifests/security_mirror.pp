class apache2::security_mirror inherits apache2 {
       file {
               "/etc/apache2/sites-available/security.debian.org":
                       source  => [ "puppet:///apache2/per-host/$fqdn/etc/apache2/sites-available/security.debian.org",
                                    "puppet:///apache2/common/etc/apache2/sites-available/security.debian.org" ],
                       require => Package["apache2"],
                       notify  => Exec["reload-apache2"];

       }

}

