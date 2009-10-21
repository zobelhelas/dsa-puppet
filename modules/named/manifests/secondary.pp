class named::secondary inherits named {
#    file { "/etc/bind/named.conf.debian-zones":
#        source  => [ "puppet:///named/per-host/$fqdn/named.conf.debian-zones",
#                     "puppet:///named/common/named.conf.debian-zones" ],
#        notify  => Exec["bind9 reload"],
#    }
}

