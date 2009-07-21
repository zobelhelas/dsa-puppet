class debian-org {
   package { "userdir-ldap": ensure => installed;
             "zsh": ensure => installed;
             "cron": ensure => installed;
             "apt-utils": ensure => installed;
             "tcsh": ensure => installed;
             "pdksh": ensure => installed;
             "ksh": ensure => installed;
             "csh": ensure => installed;
             "ntp": ensure => installed;
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
             source => "puppet:///files/etc/apt/sources.list.d/backports.org.list",
             notify  => Exec["apt-get update"];
      "/etc/apt/sources.list.d/debian.org.list":
             source => "puppet:///files/etc/apt/sources.list.d/debian.org.list",
             notify  => Exec["apt-get update"];
      "/etc/apt/sources.list.d/security.list":
             source => "puppet:///files/etc/apt/sources.list.d/security.list",
             notify  => Exec["apt-get update"];
      "/etc/apt/sources.list.d/volatile.list":
             source => "puppet:///files/etc/apt/sources.list.d/volatile.list",
             notify  => Exec["apt-get update"];
      "/etc/apt/apt.conf.d/local-recommends":
             source => "puppet:///files/etc/apt/apt.conf.d/local-recommends";
      "/etc/apt/apt.conf.d/local-pdiffs":
             source => "puppet:///files/etc/apt/apt.conf.d/local-pdiffs";
      "/etc/timezone":
             source => "puppet:///files/etc/timezone",
             notify => Exec["dpkg-reconfigure tzdata -pcritical -fnoninteractive"];
      "/etc/puppet/puppet.conf":
             source => "puppet:///files/etc/puppet/puppet.conf",
             notify  => Exec["puppet reload"];
      "/etc/default/puppet":
             source => "puppet:///files/etc/default/puppet",
             require => Exec["puppet stop"];

      "/etc/syslog-ng/syslog-ng.conf":
             source => "puppet:///files/etc/syslog-ng/syslog-ng.conf",
             notify  => Exec["syslog-ng reload"],
             ;
      "/etc/logrotate.d/syslog-ng":
             source => "puppet:///files/etc/logrotate.d/syslog-ng",
             ;
      "/etc/cron.d/dsa-puppet-stuff":
             source => "puppet:///files/etc/cron.d/dsa-puppet-stuff",
             require => Package["cron"]
             ;
      "/etc/ldap/ldap.conf":
             source => "puppet:///files/etc/ldap/ldap.conf",
             ;
      "/etc/pam.d/common-session":
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

   exec { "puppet reload":
             path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
             refreshonly => true,
   }
   exec { "puppetmaster restart":
             path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
             refreshonly => true,
   }
   exec { "puppet stop":
             path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
             refreshonly => true,
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
}

class debian-proliant inherits debian-org {
   package {
      "hpacucli": ensure => installed;
      "cpqarrayd": ensure => installed;
      "arrayprobe": ensure => installed;
   }
   file {
      "/etc/apt/sources.list.d/debian.restricted.list":
             source => "puppet:///files/etc/apt/sources.list.d/debian.restricted.list",
             notify  => Exec["apt-get update"];
   }
}
