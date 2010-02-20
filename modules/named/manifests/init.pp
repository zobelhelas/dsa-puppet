class named {
        include munin-node::bind

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
        ferm::rule { "dsa-bind":
                domain          => "(ip ip6)",
                description     => "Allow nameserver access",
                rule            => "proto (udp tcp) mod state state (NEW) dport (53) ACCEPT"
        }
}

# vim: set fdm=marker ts=8 sw=8 et:
