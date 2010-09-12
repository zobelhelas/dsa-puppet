class afs {
    @ferm::rule { "dsa-afs callback":
        domain          => "(ip ip6)",
        description  => "afs callback",
        rule         => "&SERVICE(udp, afs3-callback)"
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
