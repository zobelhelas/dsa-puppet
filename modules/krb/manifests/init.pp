class krb {
    package { "heimdal-clients": ensure => installed }

    file {
        "/etc/krb5.conf":
            content => template("krb/krb5.conf.erb"),
            require => Package["heimdal-clients"],
            ;
    }

    case $hostname {
        byrd,schuetz: {
            @ferm::rule { "dsa-krb-kdc":
                domain          => "(ip ip6)",
                description  => "kerberos KDC",
                rule         => "&TCP_UDP_SERVICE(kerberos)"
            }
        }
    }

    case $hostname {
        byrd: {
            @ferm::rule { "dsa-krb-ipropd":
                domain       => "ip",
                description  => "kerberos ipropd",
                rule         => "&SERVICE_RANGE(tcp, iprop, 206.12.19.119)",
            }
            @ferm::rule { "dsa-krb-ipropd-v6":
                domain       => 'ip6',
                description  => "kerberos ipropd (IPv6)",
                rule         => "&SERVICE_RANGE(tcp, iprop, 2607:f8f0:610:4000:216:36ff:fe40:380a)",
            }
            @ferm::rule { "dsa-krb-kpasswdd":
                domain          => "(ip ip6)",
                description  => "kerberos KDC",
                rule         => "&SERVICE(udp, kpasswd)",
            }
            @ferm::rule { "dsa-krb-kadmind":
                domain       => "ip",
                description  => "kerberos kadmind access from draghi",
                rule         => "&SERVICE_RANGE(tcp, kerberos-adm, 82.195.75.106)",
            }
            @ferm::rule { "dsa-krb-kadmind-v6":
                domain       => "ip6",
                description  => "kerberos kadmind access from draghi",
                rule         => "&SERVICE_RANGE(tcp, kerberos-adm, 2001:41b8:202:deb:216:36ff:fe40:3906)",
            }
        }
    }

}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
