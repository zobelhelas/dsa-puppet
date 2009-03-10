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
             "pciutils": ensure => latest;
             "dnsutils": ensure => latest;
             "bash-completion": ensure => latest;
             "dsa-nagios-nrpe-config": ensure => latest;
   }
   file {
      "/etc/apt/preferences":
             owner   => root,
             group   => root,
             mode    => 444,
             ensure  => file,
             source => "puppet:///files/etc/apt/preferences";
      "/etc/apt/sources.list.d/backports.org.list":
             owner   => root,
             group   => root,
             mode    => 444,
             ensure  => file,
             source => "puppet:///files/etc/apt/sources.list.d/backports.org.list";

      "/etc/apt/sources.list.d/debian.org.list":
             owner   => root,
             group   => root,
             mode    => 444,
             ensure  => file,
             source => "puppet:///files/etc/apt/sources.list.d/debian.org.list";

      "/etc/apt/sources.list.d/security.list":
             owner   => root,
             group   => root,
             mode    => 444,
             ensure  => file,
             source => "puppet:///files/etc/apt/sources.list.d/security.list";

      "/etc/apt/sources.list.d/volatile.list":
             owner   => root,
             group   => root,
             mode    => 444,
             ensure  => file,
             source => "puppet:///files/etc/apt/sources.list.d/volatile.list";
      "/etc/apt/apt.conf.d/local-recommends":
             owner   => root,
             group   => root,
             mode    => 444,
             ensure  => file,
             source => "puppet:///files/etc/apt/apt.conf.d/local-recommends";
      "/etc/puppet/puppet.conf":
             owner   => root,
             group   => root,
             mode    => 444,
             ensure  => file,
             source => "puppet:///files/etc/puppet/puppet.conf",
             notify  => Exec["puppet reload"];
      "/etc/default/puppet":
             owner   => root,
             group   => root,
             mode    => 444,
             ensure  => file,
             source => "puppet:///files/etc/default/puppet",
             notify  => Exec["puppet restart"];
   }
   exec { "puppet reload":
             path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
             refreshonly => true,
   }
   exec { "puppet restart":
             path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
             refreshonly => true,
   }
}

class debian-proliant inherits debian-org {
   package {
      "hpacucli": ensure => latest;
      "cpqarrayd": ensure => latest;
      "arrayprobe": ensure => latest;
   }
   file {
      "/etc/apt/sources.list.d/debian.restricted.list":
             owner   => root,
             group   => root,
             mode    => 444,
             ensure  => file,
             source => "puppet:///files/etc/apt/sources.list.d/debian.restricted.list";
   }
}
