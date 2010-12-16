class kfreebsd {
    file {
        "/etc/cron.d/dsa-killruby":
            source  => [ "puppet:///modules/kfreebsd/dsa-killruby" ],
            ;
    }
    sysctl {
        "maxfiles" :
            key          => "kern.maxfiles",
            value        => 65536,
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
