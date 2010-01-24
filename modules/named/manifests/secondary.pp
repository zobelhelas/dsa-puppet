class named::secondary inherits named {
    file { "/etc/bind/named.conf.debian-zones":
        source  => [ "puppet:///named/per-host/$fqdn/named.conf.debian-zones",
                     "puppet:///named/common/named.conf.debian-zones" ],
        notify  => Exec["bind9 reload"],
    }
    file { "/etc/bind/named.conf.options":
        source  => [ "puppet:///named/per-host/$fqdn/named.conf.options-secondary",
                     "puppet:///named/common/named.conf.options-secondary" ],
        notify  => Exec["bind9 reload"],
    }
    file { "/etc/bind/named.conf.shared-keys":
        mode    => 640,
        owner   => root,
        group   => bind,
    }
}

