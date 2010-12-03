class rsyncd-log {
    package { "logrotate": ensure => installed; }

    file {
        "/etc/logrotate.d/dsa-rsyncd":
            source  => "puppet:///modules/rsyncd-log/logrotate.d-dsa-rsyncd",
            ;
        "/var/log/rsyncd":
            ensure  => directory,
            owner   => root,
            group   => root,
            mode    => 755,
            ;
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
