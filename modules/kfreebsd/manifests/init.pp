class kfreebsd {
    file {
        "/etc/cron.d/dsa-dsa-killruby":
            source  => [ "puppet:///kfreebsd/dsa-dsa-killruby" ],
            ;
    }
}
# vim:set et:
# vim:set ts=4:
# vim:set shiftwidth=4:
