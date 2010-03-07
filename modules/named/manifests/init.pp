class named {
        activate_munin_check {
                "bind":;
        }

        package {
                bind9: ensure => installed;
        }

        exec {
                "bind9 restart":
                        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
                        refreshonly => true,
                        ;
        }
        exec {
                "bind9 reload":
                        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
                        refreshonly => true,
                        ;
        }
        file {
                "/var/log/bind9":
                        ensure  => directory,
                        owner   => bind,
                        group   => bind,
                        mode    => 775,
                        ;
        }
        @ferm::rule { "dsa-bind":
                domain          => "(ip ip6)",
                description     => "Allow nameserver access",
                rule            => "&TCP_UDP_SERVICE(53)"
        }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
