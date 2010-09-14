class afs {

    file {
        "/etc/openafs/CellServDB":
            source  => "puppet:///modules/afs/CellServDB",
            require => Package["openafs-client"],
            # notify  => # something to call fs newcell maybe?
            mode    => 444
            ;
        "/etc/openafs/ThisCell":
            source  => "puppet:///modules/afs/ThisCell",
            require => Package["openafs-client"],
            mode    => 444
            ;
    }

    @ferm::rule { "dsa-afs callback":
        domain          => "(ip ip6)",
        description  => "afs callback",
        rule         => "&SERVICE(udp, afs3-callback)"
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
