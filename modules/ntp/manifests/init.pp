class ntp {
    package { ntp: ensure => installed }
    file {
        "/var/lib/ntp/":
            ensure  => directory,
            owner   => ntp,
            group   => ntp,
            mode    => 755
            ;
        "/var/lib/ntpstats":
            ensure  => directory,
            owner   => ntp,
            group   => ntp,
            mode    => 755
            ;
        "/etc/ntp.conf":
            owner   => root,
            group   => root,
            mode    => 444,
            content => template("ntp/ntp.conf"),
            notify  => Exec["ntp restart"],
            require => Package["ntp"]
            ;
        "/etc/ntp.keys.d":
            owner   => root,
            group   => ntp,
            mode    => 750,
            ensure  => directory,
            ;
    }
    case extractnodeinfo($nodeinfo, 'timeserver') {
        true: { }
        default: {
            file {
                "/etc/default/ntp":
                    owner   => root,
                    group   => root,
                    mode    => 444,
                    source  => [ "puppet:///modules/ntp/etc-default-ntp" ],
                    require => Package["ntp"],
                    notify  => Exec["ntp restart"],
                    ;

                "/etc/ntp.keys.d/ntpkey_iff_merikanto":
                    owner   => root,
                    group   => root,
                    mode    => 444,
                    source  => [ "puppet:///modules/ntp/ntpkey_iff_merikanto.pub" ],
                    require => Package["ntp"],
                    notify  => Exec["ntp restart"],
                    ;
                "/etc/ntp.keys.d/ntpkey_iff_orff":
                    owner   => root,
                    group   => root,
                    mode    => 444,
                    source  => [ "puppet:///modules/ntp/ntpkey_iff_orff.pub" ],
                    require => Package["ntp"],
                    notify  => Exec["ntp restart"],
                    ;
                "/etc/ntp.keys.d/ntpkey_iff_ravel":
                    owner   => root,
                    group   => root,
                    mode    => 444,
                    source  => [ "puppet:///modules/ntp/ntpkey_iff_ravel.pub" ],
                    require => Package["ntp"],
                    notify  => Exec["ntp restart"],
                    ;
                "/etc/ntp.keys.d/ntpkey_iff_busoni":
                    owner   => root,
                    group   => root,
                    mode    => 444,
                    source  => [ "puppet:///modules/ntp/ntpkey_iff_busoni.pub" ],
                    require => Package["ntp"],
                    notify  => Exec["ntp restart"],
                    ;
            }
        }
    }


    exec { "ntp restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
    @ferm::rule { "dsa-ntp":
        domain          => "(ip ip6)",
        description     => "Allow ntp access",
        rule            => "&SERVICE(udp, 123)"
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
