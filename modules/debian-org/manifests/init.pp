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


class debian-org {
    package {
        "apt-utils": ensure => installed;
        "bash-completion": ensure => installed;
        "bzip2": ensure => installed;
        "cron": ensure => installed;
        "csh": ensure => installed;
        "dnsutils": ensure => installed;
        "dsa-munin-plugins": ensure => installed;
        "ed": ensure => installed;
        "gnupg": ensure => installed;
        "klogd": ensure => purged;
        "ksh": ensure => installed;
        "less": ensure => installed;
        "libfilesystem-ruby1.8": ensure => installed;
        "libpam-pwdfile": ensure => installed;
        "locales-all": ensure => installed;
        "mtr-tiny": ensure => installed;
        "nload": ensure => installed;
        "pciutils": ensure => installed;
        "pdksh": ensure => installed;
        "puppet": ensure => installed;
        "rsyslog": ensure => purged;
        "sysklogd": ensure => purged;
        "syslog-ng": ensure => installed;
        "tcsh": ensure => installed;
        "userdir-ldap": ensure => installed;
        "vim": ensure => installed;
        "zsh": ensure => installed;
        "logrotate": ensure => installed;
    }
    file {
        "/etc/apt/preferences":
            source => "puppet:///files/etc/apt/preferences";
        "/etc/apt/sources.list.d/backports.org.list":
            content => template("debian-org/etc/apt/sources.list.d/backports.org.list.erb"),
            notify  => Exec["apt-get update"];
        "/etc/apt/sources.list.d/debian.org.list":
            content => template("debian-org/etc/apt/sources.list.d/debian.org.list.erb"),
            notify  => Exec["apt-get update"];
        "/etc/apt/sources.list.d/security.list":
            content => template("debian-org/etc/apt/sources.list.d/security.list.erb"),
            notify  => Exec["apt-get update"];
        "/etc/apt/sources.list.d/volatile.list":
            content => template("debian-org/etc/apt/sources.list.d/volatile.list.erb"),
            notify  => Exec["apt-get update"];
        "/etc/apt/apt.conf.d/local-recommends":
            source => "puppet:///files/etc/apt/apt.conf.d/local-recommends";
        "/etc/apt/apt.conf.d/local-pdiffs":
            source => "puppet:///files/etc/apt/apt.conf.d/local-pdiffs";
        "/etc/timezone":
            source => "puppet:///files/etc/timezone",
            notify => Exec["dpkg-reconfigure tzdata -pcritical -fnoninteractive"];
        "/etc/puppet/puppet.conf":
            require => Package["puppet"],
            source => "puppet:///files/etc/puppet/puppet.conf"
            ;
        "/etc/default/puppet":
            require => Package["puppet"],
            source => "puppet:///files/etc/default/puppet"
            ;
       
        "/etc/cron.d/dsa-puppet-stuff":
            source => "puppet:///files/etc/cron.d/dsa-puppet-stuff",
            require => Package["cron"]
            ;
        "/etc/ldap/ldap.conf":
            require => Package["userdir-ldap"],
            source => "puppet:///files/etc/ldap/ldap.conf",
            ;
        "/etc/pam.d/common-session":
            require => Package["libpam-pwdfile"],
            source => "puppet:///files/etc/pam.d/common-session",
            ;
        "/etc/rc.local":
            mode   => 0775,
            source => "puppet:///modules/debian-org/rc.local",
            notify => Exec["rc.local start"],
            ;
    }
    case $hostname {
        handel: {
            file {
                "/etc/puppet/lib":
                    ensure  => directory,
                    source => "puppet:///files/etc/puppet/lib",
                    recurse => true,
                    notify  => Exec["puppetmaster restart"];
             }
         }
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
        "cpqarrayd": ensure => installed;
        "arrayprobe": ensure => installed;
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
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
