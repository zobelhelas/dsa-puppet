class rsyncd-log {
    file {
        "/etc/logrotate.d/dsa-rsyncd":
            source  => "puppet:///modules/rsyncd-log/logrotate.d-dsa-rsyncd",
            require => Package["debian.org"],
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
