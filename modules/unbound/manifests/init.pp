class unbound {
    package {
        unbound: ensure => installed;
    }

    exec {
        "unbound restart":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true,
            ;
    }
    file {
        "/var/lib/unbound":
            ensure  => directory,
            owner   => unbound,
            group   => unbound,
            mode    => 775,
            ;
    }
    file {
        "/var/lib/unbound/root.key":
            ensure  => present,
            replace => false,
            owner   => unbound,
            group   => unbound,
            mode    => 644,
            source  => [ "puppet:///modules/unbound/root.key" ],
            #notify  => Exec["unbound restart"],
            ;
    }
    file {
        "/var/lib/unbound/debian.org.key":
            ensure  => present,
            replace => false,
            owner   => unbound,
            group   => unbound,
            mode    => 644,
            source  => [ "puppet:///modules/unbound/debian.org.key" ],
            #notify  => Exec["unbound restart"],
            ;
    }
    file {
        "/etc/unbound/unbound.conf":
            content => template("unbound/unbound.conf.erb"),
            require => Package["unbound"],
            notify  => Exec["unbound restart"],
            owner   => root,
            group   => root,
            ;
    }

    case getfromhash($nodeinfo, 'misc', 'resolver-recursive') {
        true: {
            case getfromhash($nodeinfo, 'hoster', 'allow_dns_query') {
                false: {}
                default: {
                    @ferm::rule { "dsa-dns":
                        domain          => "ip",
                        description     => "Allow nameserver access",
                        rule            => sprintf("&TCP_UDP_SERVICE_RANGE(53, (%s))", join_spc(filter_ipv4(getfromhash($nodeinfo, 'hoster', 'allow_dns_query')))),
                    }
                    @ferm::rule { "dsa-dns6":
                        domain          => "ip6",
                        description     => "Allow nameserver access",
                        rule            => sprintf("&TCP_UDP_SERVICE_RANGE(53, (%s))", join_spc(filter_ipv6(getfromhash($nodeinfo, 'hoster', 'allow_dns_query')))),
                    }
                }
            }
        }
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
