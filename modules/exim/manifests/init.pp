class exim {

    package { exim4-daemon-heavy: ensure => latest }

    file { 
        "/etc/exim4/exim4.conf":
          owner   => root,
          group   => root,
          mode    => 664,
          source  => [ "puppet:///exim/per-host/$fqdn/exim4.conf",
                       "puppet:///exim/common/exim4.conf" ],
          require => Package["exim4-daemon-heavy"],
          notify  => Exec["exim4 reload"]
          ;
        "/etc/exim4/blacklist":
          owner   => root,
          group   => root,
          mode    => 664,
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/blacklist",
                       "puppet:///exim/common/" ]
          ;
        "/etc/exim4/callout_users":
          owner   => root,
          group   => root,
          mode    => 664,
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/callout_users",
                       "puppet:///exim/common/" ]
          ;
        "/etc/exim4/grey_users":
          owner   => root,
          group   => root,
          mode    => 664,
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/grey_users",
                       "puppet:///exim/common/" ]
          ;
        "/etc/exim4/helo-check":
          owner   => root,
          group   => root,
          mode    => 664,
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/helo-check",
                       "puppet:///exim/common/" ]
          ;
        "/etc/exim4/localusers":
          owner   => root,
          group   => root,
          mode    => 664,
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/localusers",
                       "puppet:///exim/common/" ]
          ;
        "/etc/exim4/rbllist":
          owner   => root,
          group   => root,
          mode    => 664,
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/rbllist",
                       "puppet:///exim/common/" ]
          ;
        "/etc/exim4/rcpthosts":
          owner   => root,
          group   => root,
          mode    => 664,
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/rcpthosts",
                       "puppet:///exim/common/" ]
          ;
        "/etc/exim4/rhsbllist":
          owner   => root,
          group   => root,
          mode    => 664,
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/rhsbllist",
                       "puppet:///exim/common/" ]
          ;
        "/etc/exim4/virtualdomains":
          owner   => root,
          group   => root,
          mode    => 664,
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/virtualdomains",
                       "puppet:///exim/common/" ]
          ;
        "/etc/exim4/whitelist":
          owner   => root,
          group   => root,
          mode    => 664,
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/per-host/$fqdn/whitelist",
                       "puppet:///exim/common/" ]
          ;
    }

    exec { "exim4 reload":
        path        => "/etc/init.d/",
        refreshonly => true,
    }
}

