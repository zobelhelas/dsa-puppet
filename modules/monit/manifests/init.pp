class monit {
    package { "monit": ensure => installed }

    file {
        "/etc/monit/monitrc":
          source  => "puppet:///monit/monitrc",
          require => Package["monit"],
          notify  => Exec["monit restart"],
          mode    => 440
          ;

        "/etc/monit/monit.d":
          ensure  => directory,
          owner   => root,
          group   => root,
          mode    => 750,
          purge   => true
          ;

        "/etc/monit/monit.d/01puppet":
          source  => "puppet:///monit/puppet",
          require => Package["monit"],
          notify  => Exec["monit restart"],
          mode    => 440
          ;

        "/etc/monit/monit.d/00debian.org":
          source  => "puppet:///monit/debianorg",
          require => Package["monit"],
          notify  => Exec["monit restart"],
          mode    => 440
          ;

        "/etc/default/monit":
          source  => "puppet:///monit/default",
          require => Package["monit"],
          notify  => Exec["monit restart"]
          ;
    }
    exec { "monit restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}

