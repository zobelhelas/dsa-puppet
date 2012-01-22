class nagios::client inherits nagios {
    package {
        dsa-nagios-nrpe-config: ensure => purged;
        dsa-nagios-checks: ensure => installed;
    }

    file {
        "/etc/default/nagios-nrpe-server":
            source  => [ "puppet:///modules/nagios/per-host/$fqdn/default",
                         "puppet:///modules/nagios/common/default" ],
            require => Package["nagios-nrpe-server"],
            notify  => Exec["nagios-nrpe-server restart"],
            ;
        "/etc/default/nagios-nrpe":
            ensure  => absent,
            notify  => Exec["nagios-nrpe-server restart"],
            ;
        "/etc/nagios/nrpe.cfg":
            content => template("nagios/nrpe.cfg.erb"),
            require => Package["nagios-nrpe-server"],
            notify  => Exec["service nagios-nrpe-server reload"],
            ;
        "/etc/nagios/nrpe.d":
            mode    => 755,
            require => Package["nagios-nrpe-server"],
            ensure  => directory,
            ;
        "/etc/nagios/nrpe.d/debianorg.cfg":
            content => template("nagios/inc-debian.org.erb"),
            require => Package["nagios-nrpe-server"],
            notify  => Exec["service nagios-nrpe-server reload"],
            ;
        "/etc/nagios/nrpe.d/nrpe_dsa.cfg":
            source  => [ "puppet:///modules/nagios/dsa-nagios/generated/nrpe_dsa.cfg" ],
            require => Package["dsa-nagios-checks"],
            notify  => Exec["service nagios-nrpe-server reload"],
            ;

        "/etc/nagios/obsolete-packages-ignore":
            source  => [ "puppet:///modules/nagios/per-host/$fqdn/obsolete-packages-ignore",
                         "puppet:///modules/nagios/common/obsolete-packages-ignore" ],
            require => Package["dsa-nagios-checks"],
            ;

        "/etc/nagios/obsolete-packages-ignore.d/hostspecific":
                        content => template("nagios/obsolete-packages-ignore.d-hostspecific.erb"),
            require => Package["dsa-nagios-checks"],
            ;
    }

    exec {
        "nagios-nrpe-server restart":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true,
            ;
        "service nagios-nrpe-server reload":
            refreshonly => true,
            ;
    }

    @ferm::rule {
        "dsa-nagios-v4":
            description     => "Allow nrpe from nagios master",
            rule            => "proto tcp mod state state (NEW) dport (5666) @subchain 'nagios' { saddr (\$HOST_NAGIOS_V4) ACCEPT; }",
            notarule        => true,
            ;
        "dsa-nagios-v6":
            description     => "Allow nrpe from nagios master",
            domain          => "ip6",
            rule            => "proto tcp mod state state (NEW) dport (5666) @subchain 'nagios' { saddr (\$HOST_NAGIOS_V6) ACCEPT; }",
            notarule        => true,
            ;
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
