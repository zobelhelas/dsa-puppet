class exim {

    package { exim4-daemon-heavy: ensure => installed }

    file {
        "/etc/exim4/":
          ensure  => directory,
          owner   => root,
          group   => root,
          mode    => 755,
          purge   => true
        ;
        "/etc/exim4/ssl":
          ensure  => directory,
          owner   => root,
          group   => Debian-exim,
          mode    => 750,
          purge   => true
        ;
        "/etc/exim4/exim4.conf":
          source  => [ "puppet:///exim/per-host/$fqdn/exim4.conf",
                       "puppet:///exim/common/exim4.conf" ],
          require => Package["exim4-daemon-heavy"],
          notify  => Exec["exim4 reload"]
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
          source  => [ "puppet:///exim/per-host/$fqdn/locals",
                       "puppet:///exim/common/locals" ]
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
        "/etc/exim4/rcpthosts":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/rcpthosts",
                       "puppet:///exim/common/rcpthosts" ]
          ;
        "/etc/exim4/rhsbllist":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/rhsbllist",
                       "puppet:///exim/common/rhsbllist" ]
          ;
        "/etc/exim4/virtualdomains":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/virtualdomains",
                       "puppet:///exim/common/virtualdomains" ]
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
        "/etc/exim4/local-auto.conf":
          require => Package["exim4-daemon-heavy"],
          content => template("exim-local-auto.erb")
          ;
        "/etc/exim4/ssl/thishost.crt":
          require => Package["exim4-daemon-heavy"],
          source  => "puppet:///exim/certs/$fqdn.crt"
          owner   => root,
          group   => Debian-exim,
          mode    => 640,
          ;
        "/etc/exim4/ssl/thishost.key":
          require => Package["exim4-daemon-heavy"],
          source  => "puppet:///exim/certs/$fqdn.key"
          owner   => root,
          group   => Debian-exim,
          mode    => 640,
          ;
    }

    exec { "exim4 reload":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}

class eximmx inherits exim {
    include clamav
    include postgrey
}
