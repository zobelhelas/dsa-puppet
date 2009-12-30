class exim {
    activate_munin_check {
            "ps_exim4": script => "ps_";
            "exim_mailqueue":;
            "exim_mailstats":;
            "postfix_mailqueue":  ensure => absent;
            "postfix_mailstats":  ensure => absent;
            "postfix_mailvolume": ensure => absent;
    }


    package { exim4-daemon-heavy: ensure => installed }

    file {
        "/etc/exim4/":
          ensure  => directory,
          owner   => root,
          group   => root,
          mode    => 755,
          purge   => true
        ;
        "/etc/exim4/Git":
          ensure  => directory,
          purge   => true,
          force   => true,
          recurse => true,
          source  => "puppet:///files/empty/"
        ;
        "/etc/exim4/conf.d":
          ensure  => directory,
          purge   => true,
          force   => true,
          recurse => true,
          source  => "puppet:///files/empty/"
        ;
        "/etc/exim4/ssl":
          ensure  => directory,
          owner   => root,
          group   => Debian-exim,
          mode    => 750,
          require => Package["exim4-daemon-heavy"],
          purge   => true
        ;
        "/etc/mailname":
          content => template("exim/mailname.erb"),
        ;
        "/etc/exim4/exim4.conf":
          content => template("exim/eximconf.erb"),
          require => Package["exim4-daemon-heavy"],
          notify  => Exec["exim4 reload"]
        ;
        "/etc/exim4/manualroute":
          require => Package["exim4-daemon-heavy"],
          content => template("exim/manualroute.erb")
          ;
        "/etc/exim4/host_blacklist":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/host_blacklist",
                       "puppet:///exim/common/host_blacklist" ]
          ;
        "/etc/exim4/blacklist":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/blacklist",
                       "puppet:///exim/common/blacklist" ]
          ;
        "/etc/exim4/callout_users":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/callout_users",
                       "puppet:///exim/common/callout_users" ]
          ;
        "/etc/exim4/grey_users":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/grey_users",
                       "puppet:///exim/common/grey_users" ]
          ;
        "/etc/exim4/helo-check":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/helo-check",
                       "puppet:///exim/common/helo-check" ]
          ;
        "/etc/exim4/locals":
          require => Package["exim4-daemon-heavy"],
          content => template("exim/locals.erb")
          ;
        "/etc/exim4/localusers":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/localusers",
                       "puppet:///exim/common/localusers" ]
          ;
        "/etc/exim4/rbllist":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/rbllist",
                       "puppet:///exim/common/rbllist" ]
          ;
        "/etc/exim4/rhsbllist":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/rhsbllist",
                       "puppet:///exim/common/rhsbllist" ]
          ;
        "/etc/exim4/virtualdomains":
          require => Package["exim4-daemon-heavy"],
          content => template("exim/virtualdomains.erb")
          ;
        "/etc/exim4/whitelist":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/whitelist",
                       "puppet:///exim/common/whitelist" ]
          ;
        "/etc/logrotate.d/exim4-base":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/logrotate-exim4-base",
                       "puppet:///exim/common/logrotate-exim4-base" ]
          ;
        "/etc/logrotate.d/exim4-paniclog":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/logrotate-exim4-paniclog",
                       "puppet:///exim/common/logrotate-exim4-paniclog" ]
          ;
        "/etc/exim4/ssl/thishost.crt":
          require => Package["exim4-daemon-heavy"],
          source  => "puppet:///exim/certs/$fqdn.crt",
          owner   => root,
          group   => Debian-exim,
          mode    => 640
          ;
        "/etc/exim4/ssl/thishost.key":
          require => Package["exim4-daemon-heavy"],
          source  => "puppet:///exim/certs/$fqdn.key",
          owner   => root,
          group   => Debian-exim,
          mode    => 640
          ;
        "/etc/exim4/ssl/ca.crt":
          require => Package["exim4-daemon-heavy"],
          source  => "puppet:///exim/certs/ca.crt",
          owner   => root,
          group   => Debian-exim,
          mode    => 640
          ;
        "/etc/exim4/ssl/ca.crl":
          require => Package["exim4-daemon-heavy"],
          source  => "puppet:///exim/certs/ca.crl",
          owner   => root,
          group   => Debian-exim,
          mode    => 640
          ;
        "/var/log/exim4":
          mode    => 2750,
          ensure  => directory
          owner   => Debian-exim,
          group   => maillog
          ;
    }

    exec { "exim4 reload":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}
