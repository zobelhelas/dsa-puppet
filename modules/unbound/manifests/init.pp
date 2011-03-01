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
            # IANA root trust anchor, valid from 2010-07-15T00:00:00+00:00
            # downloaded from https://data.iana.org/root-anchors/root-anchors.xml
            content => ". IN DS 19036 8 2 49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5\n",
            notify  => Exec["unbound restart"],
            ;
        "/var/lib/unbound/debian.org.key":
            ensure  => present,
            replace => false,
            owner   => unbound,
            group   => unbound,
            mode    => 644,
            # debian.org DS record, July 2010'
            content => "debian.org. IN DS 5283 7 2 3DC987A633914C195D03EA129E92327630D3428E92884A5E97829A55701F9E8A\n",
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
