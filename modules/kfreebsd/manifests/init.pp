class kfreebsd {
    file {
        "/etc/cron.d/dsa-killruby":
            source  => [ "puppet:///kfreebsd/dsa-killruby" ],
            ;
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
