class geodns {

    package { pdns-backend-geo: ensure => installed }

    file { "/etc/powerdns/pdns.conf":
        source  => [ "puppet:///geodns/per-host/$fqdn/pdns.conf",
                     "puppet:///geodns/common/pdns.conf" ],
        require => Package["pdns-backend-geo"],
        notify  => Exec["pdns restart"],
    }
    file { "/etc/powerdns/pdns.d/pdns.local":
        source  => [ "puppet:///geodns/per-host/$fqdn/pdns.local",
                     "puppet:///geodns/common/pdns.local" ],
        require => Package["pdns-backend-geo"],
        notify  => Exec["pdns restart"],
    }
    file { "/etc/powerdns/ip2iso":
        source  => [ "puppet:///geodns/per-host/$fqdn/ip2iso",
                     "puppet:///geodns/common/ip2iso" ],
        require => Package["pdns-backend-geo"],
        notify  => Exec["pdns restart"],
    }
    file { "/etc/powerdns/iso2ga/security":
        source  => [ "puppet:///geodns/per-host/$fqdn/security",
                     "puppet:///geodns/common/security" ],
        require => Package["pdns-backend-geo"],
        notify  => Exec["pdns restart"],
    }
    file { "/etc/powerdns/iso2ga/security6":
        source  => [ "puppet:///geodns/per-host/$fqdn/security6",
                     "puppet:///geodns/common/security6" ],
        require => Package["pdns-backend-geo"],
        notify  => Exec["pdns restart"],
    }

    exec { "pdns restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}

