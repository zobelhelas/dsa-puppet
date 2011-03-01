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
          source  => [ "puppet:///modules/exim/per-host/$fqdn/host_blacklist",
                       "puppet:///modules/exim/common/host_blacklist" ]
          ;
        "/etc/exim4/blacklist":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/per-host/$fqdn/blacklist",
                       "puppet:///modules/exim/common/blacklist" ]
          ;
        "/etc/exim4/callout_users":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/per-host/$fqdn/callout_users",
                       "puppet:///modules/exim/common/callout_users" ]
          ;
        "/etc/exim4/grey_users":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/per-host/$fqdn/grey_users",
                       "puppet:///modules/exim/common/grey_users" ]
          ;
        "/etc/exim4/helo-check":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/per-host/$fqdn/helo-check",
                       "puppet:///modules/exim/common/helo-check" ]
          ;
        "/etc/exim4/locals":
          require => Package["exim4-daemon-heavy"],
          content => template("exim/locals.erb")
          ;
        "/etc/exim4/localusers":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/per-host/$fqdn/localusers",
                       "puppet:///modules/exim/common/localusers" ]
          ;
        "/etc/exim4/rbllist":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/per-host/$fqdn/rbllist",
                       "puppet:///modules/exim/common/rbllist" ]
          ;
        "/etc/exim4/rhsbllist":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/per-host/$fqdn/rhsbllist",
                       "puppet:///modules/exim/common/rhsbllist" ]
          ;
        "/etc/exim4/virtualdomains":
          require => Package["exim4-daemon-heavy"],
          content => template("exim/virtualdomains.erb")
          ;
        "/etc/exim4/whitelist":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/per-host/$fqdn/whitelist",
                       "puppet:///modules/exim/common/whitelist" ]
          ;
        "/etc/exim4/submission-domains":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/per-host/$fqdn/submission-domains",
                       "puppet:///modules/exim/common/submission-domains" ]
          ;
        "/etc/logrotate.d/exim4-base":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/per-host/$fqdn/logrotate-exim4-base",
                       "puppet:///modules/exim/common/logrotate-exim4-base" ]
          ;
        "/etc/logrotate.d/exim4-paniclog":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/per-host/$fqdn/logrotate-exim4-paniclog",
                       "puppet:///modules/exim/common/logrotate-exim4-paniclog" ]
          ;
        "/etc/exim4/ssl/thishost.crt":
          require => Package["exim4-daemon-heavy"],
          source  => "puppet:///modules/exim/certs/$fqdn.crt",
          owner   => root,
          group   => Debian-exim,
          mode    => 640
          ;
        "/etc/exim4/ssl/thishost.key":
          require => Package["exim4-daemon-heavy"],
          source  => "puppet:///modules/exim/certs/$fqdn.key",
          owner   => root,
          group   => Debian-exim,
          mode    => 640
          ;
        "/etc/exim4/ssl/ca.crt":
          require => Package["exim4-daemon-heavy"],
          source  => "puppet:///modules/exim/certs/ca.crt",
          owner   => root,
          group   => Debian-exim,
          mode    => 640
          ;
        "/etc/exim4/ssl/ca.crl":
          require => Package["exim4-daemon-heavy"],
          source  => "puppet:///modules/exim/certs/ca.crl",
          owner   => root,
          group   => Debian-exim,
          mode    => 640
          ;
        "/var/log/exim4":
          mode    => 2750,
          ensure  => directory,
          owner   => Debian-exim,
          group   => maillog
          ;
    }

    exec { "exim4 reload":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }

    case getfromhash($nodeinfo, 'mail_port') {
      /^(\d+)$/: { $mail_port = $1 }
      default: { $mail_port = 'smtp' }
    }

    @ferm::rule { "dsa-exim":
            description     => "Allow SMTP",
            rule            => "&SERVICE_RANGE(tcp, $mail_port, \$SMTP_SOURCES)"
    }
    @ferm::rule { "dsa-exim-v6":
            description     => "Allow SMTP",
            domain          => "ip6",
            rule            => "&SERVICE_RANGE(tcp, $mail_port, \$SMTP_V6_SOURCES)"
    }
    # Do we actually want this?  I'm only doing it because it's harmless
    # and makes the logs quiet.  There are better ways of making logs quiet,
    # though.
    @ferm::rule { "dsa-ident":
            domain          => "(ip ip6)",
            description     => "Allow ident access",
            rule            => "&SERVICE(tcp, 113)"
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
