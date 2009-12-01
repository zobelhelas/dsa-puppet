define sysctl($key, $value, $ensure=present) {
    file { "/etc/sysctl.d/$name.conf":
        ensure  => $ensure,
        owner   => root,
        group   => root,
        mode    => 0644,
        content => "$key = $value\n",
        notify  => Exec["procps restart"],
    }
}

define set_alternatives($linkto) {
        exec { "/usr/sbin/update-alternatives --set $name $linkto":
            unless => "/bin/sh -c '! [ -e $linkto ] || ! [ -e /etc/alternatives/$name ] || ([ -L /etc/alternatives/$name ] && [ /etc/alternatives/$name -ef $linkto ])'"
        }
}


class debian-org {
   package { "userdir-ldap": ensure => installed;
             "zsh": ensure => installed;
             "cron": ensure => installed;
             "apt-utils": ensure => installed;
             "tcsh": ensure => installed;
             "pdksh": ensure => installed;
             "ksh": ensure => installed;
             "csh": ensure => installed;
             "locales-all": ensure => installed;
             "libpam-pwdfile": ensure => installed;
             "vim": ensure => installed;
             "gnupg": ensure => installed;
             "bzip2": ensure => installed;
             "less": ensure => installed;
             "ed": ensure => installed;
             "puppet": ensure => installed;
             "mtr-tiny": ensure => installed;
             "nload": ensure => installed;
             "pciutils": ensure => installed;
             "dnsutils": ensure => installed;
             "bash-completion": ensure => installed;
             "libfilesystem-ruby1.8": ensure => installed;
             "syslog-ng": ensure => installed;
             "sysklogd": ensure => purged;
             "klogd": ensure => purged;
             "rsyslog": ensure => purged;
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

      "/etc/syslog-ng/syslog-ng.conf":
             content => template("syslog-ng.conf.erb"),
             require => Package["syslog-ng"],
             notify  => Exec["syslog-ng reload"],
             ;
      "/etc/logrotate.d/syslog-ng":
             require => Package["syslog-ng"],
             source => "puppet:///files/etc/logrotate.d/syslog-ng",
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
        default: {}
   }

   # set mmap_min_addr to 4096 to mitigate
   # Linux NULL-pointer dereference exploits
   sysctl { "mmap_min_addr" :
             key         => "vm.mmap_min_addr",
             value       => 4096,
   }

   set_alternatives { "editor":
           linkto => "/usr/bin/vim.basic",
   }

   exec { "syslog-ng reload":
             path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
             refreshonly => true,
   }
   exec { "dpkg-reconfigure tzdata -pcritical -fnoninteractive":
           path        => "/usr/bin:/usr/sbin:/bin:/sbin",
           refreshonly => true,
   }
   exec { "apt-get update":
             command => 'apt-get update',
             path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
             refreshonly => true
   }
   exec { "puppetmaster restart":
             path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
             refreshonly => true,
   }
   exec { "procps restart":
             path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
             refreshonly => true,
   }
}

class debian-proliant inherits debian-org {
   package {
      "hpacucli": ensure => installed;
      "hp-health": ensure => installed;
      "cpqarrayd": ensure => installed;
      "arrayprobe": ensure => installed;
   }
   case $architecture {
      "amd64" {
         package { "lib32gcc1": ensure => installed; }
      }
   }
   file {
      "/etc/apt/sources.list.d/debian.restricted.list":
             content => template("debian-org/etc/apt/sources.list.d/debian.restricted.list.erb"),
             notify  => Exec["apt-get update"];
   }
}
