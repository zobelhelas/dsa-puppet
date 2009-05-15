class named-secondary {
    file { "/etc/bind/named.conf.debian-zones":
        source  => [ "puppet:///named-secondary/per-host/$fqdn/named.conf.debian-zones",
                     "puppet:///named-secondary/common/named.conf.debian-zones" ],
        notify  => Exec["bind9 reload"],
    }

    exec { "bind9 reload":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}

