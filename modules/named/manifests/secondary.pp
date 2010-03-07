class named::secondary inherits named {
    file { "/etc/bind/named.conf.debian-zones":
        source  => [ "puppet:///named/per-host/$fqdn/named.conf.debian-zones",
                     "puppet:///named/common/named.conf.debian-zones" ],
        notify  => Exec["bind9 reload"],
    }
    file { "/etc/bind/named.conf.shared-keys":
        mode    => 640,
        owner   => root,
        group   => bind,
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
