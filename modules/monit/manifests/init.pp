class monit {
    package { "monit": ensure => installed }

    augeas { "inittab":
        context => "/files/etc/inittab",
        changes => [ "set mo/runlevels 2345",
                     "set mo/action respawn",
                     "set mo/process \"/usr/sbin/monit -d 300 -I -c /etc/monit/monitrc -s /var/lib/monit/monit.state\"",
                   ],
        onlyif => "match mo size == 0",
        notify => Exec["init q"],
    }


    file {
        #"/etc/rc2.d/K99monit":
        #  ensure  => "../init.d/monit";
        #"/etc/rc2.d/S99monit":
        #  ensure  => absent;

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
          notify  => Exec["monit stop"],
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
          source  => "puppet:///modules/monit/puppet",
          require => Package["monit"],
          notify  => Exec["monit stop"],
          mode    => 440
          ;

        "/etc/monit/monit.d/00debian.org":
          source  => "puppet:///modules/monit/debianorg",
          require => Package["monit"],
          notify  => Exec["monit stop"],
          mode    => 440
          ;

        "/etc/default/monit":
          content => template("monit/default.erb"),
          require => Package["monit"],
          notify  => Exec["monit stop"]
          ;
    }
    exec { "monit stop":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
