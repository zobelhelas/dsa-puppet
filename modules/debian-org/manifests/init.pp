class debian-org {
   package { "userdir-ldap": ensure => latest;
             "zsh": ensure => latest;
             "tcsh": ensure => latest;
             "pdksh": ensure => latest;
             "ksh": ensure => latest;
             "csh": ensure => latest;
             "ntp": ensure => latest;
             "locales-all": ensure => latest;
             "sudo": ensure => latest;
             "libpam-pwdfile": ensure => latest;
             "vim": ensure => latest;
             "gnupg": ensure => latest;
             "bzip2": ensure => latest;
             "less": ensure => latest;
             "ed": ensure => latest;
             "puppet": ensure => latest;
             "mtr-tiny": ensure => latest;
             "nload": ensure => latest;
   }
   file {
      "/etc/apt/sources.list.d/backports.org.list":
             source => "puppet:///files/etc/apt/sources.list.d/backports.org.list";

      "/etc/apt/sources.list.d/debian.org.list":
             source => "puppet:///files/etc/apt/sources.list.d/debian.org.list";

      "/etc/apt/sources.list.d/security.list":
             source => "puppet:///files/etc/apt/sources.list.d/security.list";

      "/etc/apt/sources.list.d/volatile.list":
             source => "puppet:///files/etc/apt/sources.list.d/volatile.list";
      "/etc/apt/apt.conf.d/local-recommends":
             source => "puppet:///files/etc/apt/apt.conf.d/local-recommends";
   }
}



