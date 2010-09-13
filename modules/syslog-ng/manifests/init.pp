class syslog-ng {
    file {
        "/etc/syslog-ng/syslog-ng.conf":
            content => template("syslog-ng/syslog-ng.conf.erb"),
            require => Package["syslog-ng"],
            notify  => Exec["syslog-ng reload"],
            ;
        "/etc/logrotate.d/syslog-ng":
            require => Package["syslog-ng"],
            source => "puppet:///modules/syslog-ng/syslog-ng.logrotate",
            ;
    }
    exec {
        "syslog-ng reload":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true;
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
