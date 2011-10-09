define sysctl($key, $value, $ensure=present) {
    file {
        "/etc/sysctl.d/$name.conf":
            ensure  => $ensure,
            owner   => root,
            group   => root,
            mode    => 0644,
            content => "$key = $value\n",
            notify  => Exec["procps restart"],
    }
}

define set_alternatives($linkto) {
    exec {
        "/usr/sbin/update-alternatives --set $name $linkto":
            unless => "/bin/sh -c '! [ -e $linkto ] || ! [ -e /etc/alternatives/$name ] || ([ -L /etc/alternatives/$name ] && [ /etc/alternatives/$name -ef $linkto ])'"
        }
}

define linux_module ($ensure) {
    case $ensure {
        present: {
            exec { "append_module_${name}":
                command => "echo '${name}' >> /etc/modules",
                unless => "grep -q -F -x '${name}' /etc/modules",
            }
        }
        absent: {
            exec { "remove_module_${name}":
                command => "sed -i -e'/^${name}\$/d' /etc/modules",
                onlyif => "grep -q -F -x '${name}' /etc/modules",
            }
        }
        default: {
             err("invalid ensure value ${ensure}")
         }
    }
}


class debian-org {
    $debianadmin = [ "debian-archive-debian-samhain-reports@master.debian.org", "debian-admin@ftbfs.de", "weasel@debian.org", "steve@lobefin.net", "paravoid@debian.org" ]
    package {
        "apt-utils": ensure => installed;
        "bash-completion": ensure => installed;
        "debian.org": ensure => installed;
        "dnsutils": ensure => installed;
        "dsa-munin-plugins": ensure => installed;
        "klogd": ensure => purged;
        "less": ensure => installed;
        "libfilesystem-ruby1.8": ensure => installed;
        "mtr-tiny": ensure => installed;
        "nload": ensure => installed;
        "pciutils": ensure => installed;
        "rsyslog": ensure => purged;
        "sysklogd": ensure => purged;
    }
    case $debarchitecture {
        "armhf":
        default:
            file {
                "/etc/apt/sources.list.d/security.list":
                    content => template("debian-org/etc/apt/sources.list.d/security.list.erb"),
                    notify  => Exec["apt-get update"];
                "/etc/apt/sources.list.d/backports.org.list":
                    content => template("debian-org/etc/apt/sources.list.d/backports.org.list.erb"),
                    notify  => Exec["apt-get update"];
            }
    file {
        "/etc/apt/preferences":
            source => "puppet:///modules/debian-org/apt.preferences";
        "/etc/apt/sources.list.d/debian.org.list":
            content => template("debian-org/etc/apt/sources.list.d/debian.org.list.erb"),
            notify  => Exec["apt-get update"];
        "/etc/apt/sources.list.d/volatile.list":
            content => template("debian-org/etc/apt/sources.list.d/volatile.list.erb"),
            notify  => Exec["apt-get update"];
        "/etc/apt/apt.conf.d/local-recommends":
            source => "puppet:///modules/debian-org/apt.conf.d/local-recommends";
        "/etc/apt/apt.conf.d/local-pdiffs":
            source => "puppet:///modules/debian-org/apt.conf.d/local-pdiffs";
        "/etc/timezone":
            source => "puppet:///modules/debian-org/timezone",
            notify => Exec["dpkg-reconfigure tzdata -pcritical -fnoninteractive"];
        "/etc/puppet/puppet.conf":
            # require => Package["puppet"],
            source => "puppet:///modules/debian-org/puppet.conf"
            ;
        "/etc/default/puppet":
            # require => Package["puppet"],
            source => "puppet:///modules/debian-org/puppet.default"
            ;

        "/etc/cron.d/dsa-puppet-stuff":
            source => "puppet:///modules/debian-org/dsa-puppet-stuff.cron",
            require => Package["debian.org"]
            ;
        "/etc/ldap/ldap.conf":
            require => Package["debian.org"],
            source => "puppet:///modules/debian-org/ldap.conf",
            ;
        "/etc/pam.d/common-session":
            require => Package["debian.org"],
            content => template("debian-org/pam.common-session.erb"),
            ;
        "/etc/rc.local":
            mode   => 0755,
            source => "puppet:///modules/debian-org/rc.local",
            notify => Exec["rc.local start"],
            ;

        "/etc/dsa":
            mode   => 0755,
            ensure  => directory,
            ;
        "/etc/dsa/cron.ignore.dsa-puppet-stuff":
            source => "puppet:///modules/debian-org/dsa-puppet-stuff.cron.ignore",
            require => Package["debian.org"]
            ;
    }
   
    # set mmap_min_addr to 4096 to mitigate
    # Linux NULL-pointer dereference exploits
    sysctl {
        "mmap_min_addr" :
            key         => "vm.mmap_min_addr",
            value       => 4096,
    }
   
    set_alternatives {
        "editor":
            linkto => "/usr/bin/vim.basic",
    }
   
    mailalias {
        "samhain-reports":
            recipient => $debianadmin,
            ensure => present;
    }

    exec {
        "dpkg-reconfigure tzdata -pcritical -fnoninteractive":
            path        => "/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true;
        "apt-get update":
            command => 'apt-get update',
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true;
        "puppetmaster restart":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true;
        "rc.local start":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true;
        "procps restart":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true;
        "init q":
            refreshonly => true;
    }
}

class debian-proliant inherits debian-org {
    package {
        "hpacucli": ensure => installed;
        "hp-health": ensure => installed;
        "arrayprobe": ensure => installed;
    }
    case getfromhash($nodeinfo, 'squeeze') {
        true: {}
        default: {
            package {
                "cpqarrayd": ensure => installed;
            }
        }
    }
    case $debarchitecture {
        "amd64": {
            package { "lib32gcc1": ensure => installed; }
        }
    }
    file {
        "/etc/apt/sources.list.d/debian.restricted.list":
            content => template("debian-org/etc/apt/sources.list.d/debian.restricted.list.erb"),
            notify  => Exec["apt-get update"];
    }
}

class debian-radvd inherits debian-org {
    sysctl {
        "dsa-accept-ra-default" :
            key         => "net.ipv6.conf.default.accept_ra",
            value       => 0,
    }
    sysctl {
        "dsa-accept-ra-all" :
            key         => "net.ipv6.conf.all.accept_ra",
            value       => 0,
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
