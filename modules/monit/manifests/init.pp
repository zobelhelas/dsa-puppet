class monit {
    package { "monit": ensure => installed }

    file {
        "/etc/monit/":
          ensure  => directory,
          owner   => root,
          group   => root,
          mode    => 755,
          purge   => true
          ;

        "/etc/monit/monitrc":
          content => template("monit/monitrc.erb"),
          require => Package["monit"],
          notify  => Exec["monit restart"],
          mode    => 400
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
          content => template("monit/default.erb"),
          require => Package["monit"],
          notify  => Exec["monit restart"]
          ;
    }
    exec { "monit restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
