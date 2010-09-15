class afs {
    package {
        "openafs-client":
            ensure => installed,
            require => File['/etc/openafs/CellServDB',
                            '/etc/openafs/ThisCell',
                            '/etc/openafs/afs.conf.client'],
            ;
        "openafs-krb5":
            ensure => installed,
            ;
    }
    file {
        "/etc/openafs":
            ensure  => directory,
            mode    => 755,
            ;
        "/etc/openafs/CellServDB":
            source  => "puppet:///modules/afs/CellServDB",
            # notify  => # something to call fs newcell maybe?
            mode    => 444
            ;
        "/etc/openafs/ThisCell":
            source  => "puppet:///modules/afs/ThisCell",
            mode    => 444
            ;
        "/etc/openafs/afs.conf.client":
            source  => "puppet:///modules/afs/afs.conf.client",
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
