class raidmpt {
    package {
        mtp-status: ensure => installed;
    }

    file {
        "/etc/default/mpt-statusd":
            content =>  "# This file is under puppet control\nRUN_DAEMON=no",
            notify  => Exec["mpt-statusd-stop"],
            ;
    }
    exec {
        "mpt-statusd-stop":
            command => 'pidfile=/var/run/mpt-statusd.pid; ! [ -e "$pidfile" ] || /sbin/start-stop-daemon --oknodo --stop --quiet --pidfile "$pidfile"; rm -f "$pidfile"',
            refreshonly => true,
            ;
    }
}
# vim:set et:
# vim:set ts=4:
# vim:set shiftwidth=4:
