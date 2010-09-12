class afs::server inherits afs {
    @ferm::rule { "dsa-afs fileserver":
        domain       => "(ip ip6)",
        description  => "afs callback",
        rule         => "&SERVICE(udp, afs3-fileserver)"
    }
    @ferm::rule { "dsa-afs prserver":
        domain       => "(ip ip6)",
        description  => "afs callback",
        rule         => "&SERVICE(udp, afs3-prserver)"
    }
    @ferm::rule { "dsa-afs vlserver":
        domain       => "(ip ip6)",
        description  => "afs callback",
        rule         => "&SERVICE(udp, afs3-vlserver)"
    }
    @ferm::rule { "dsa-afs kaserver":
        domain       => "(ip ip6)",
        description  => "afs callback",
        rule         => "&SERVICE(udp, afs3-kaserver)"
    }
    @ferm::rule { "dsa-afs volser":
        domain       => "(ip ip6)",
        description  => "afs callback",
        rule         => "&SERVICE(udp, afs3-volser)"
    }
    #@ferm::rule { "dsa-afs bos":
    #    domain       => "(ip ip6)",
    #    description  => "afs callback",
    #    rule         => "&SERVICE(udp, afs3-bos)"
    #}
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
