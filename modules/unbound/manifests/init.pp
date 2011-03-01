class unbound {
    package {
        unbound: ensure => installed;
    }

    exec {
        "unbound restart":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true,
            ;
    }
    file {
        "/var/lib/unbound":
            ensure  => directory,
            owner   => unbound,
            group   => unbound,
            mode    => 775,
            ;
        "/var/lib/unbound/root.key":
            ensure  => present,
            replace => false,
            owner   => unbound,
            group   => unbound,
            mode    => 644,
            source  => [ "puppet:///modules/unbound/root.key" ],
            notify  => Exec["unbound restart"],
            ;
        "/var/lib/unbound/debian.org.key":
            ensure  => present,
            replace => false,
            owner   => unbound,
            group   => unbound,
            mode    => 644,
            source  => [ "puppet:///modules/unbound/debian.org.key" ],
            notify  => Exec["unbound restart"],
            ;
        "/etc/unbound/unbound.conf":
            content => template("unbound/unbound.conf.erb"),
            require => Package["unbound"],
            notify  => Exec["unbound restart"],
            owner   => root,
            group   => root,
            ;
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
