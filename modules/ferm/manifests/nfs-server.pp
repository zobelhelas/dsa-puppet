class ferm::nfs-server {
    @ferm::rule { "dsa-portmap":
            domain          => "(ip ip6)",
            description     => "Allow portmap access",
            rule            => "&TCP_UDP_SERVICE(111)"
    }
    @ferm::rule { "dsa-nfs":
            domain          => "(ip ip6)",
            description     => "Allow nfsd access",
            rule            => "&TCP_UDP_SERVICE(2049)"
    }
    @ferm::rule { "dsa-status":
            domain          => "(ip ip6)",
            description     => "Allow statd access",
            rule            => "&TCP_UDP_SERVICE(10000)"
    }
    @ferm::rule { "dsa-mountd":
            domain          => "(ip ip6)",
            description     => "Allow mountd access",
            rule            => "&TCP_UDP_SERVICE(10002)"
    }
    @ferm::rule { "dsa-lockd":
            domain          => "(ip ip6)",
            description     => "Allow lockd access",
            rule            => "&TCP_UDP_SERVICE(10003)"
    }
}
