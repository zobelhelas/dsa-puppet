class exim::mx inherits exim {
    include clamav
    include postgrey

    file {
        "/etc/exim4/ccTLD.txt":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/common/ccTLD.txt" ]
          ;
        "/etc/exim4/surbl_whitelist.txt":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/common/surbl_whitelist.txt" ]
          ;
        "/etc/exim4/exim_surbl.pl":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///modules/exim/common/exim_surbl.pl" ],
          notify  => Exec["exim4 restart"]
          ;
    }
    exec { "exim4 restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
    @ferm::rule { "dsa-exim-submission":
            description     => "Allow SMTP",
            rule            => "&SERVICE_RANGE(tcp, submission, \$SMTP_SOURCES)"
    }
    @ferm::rule { "dsa-exim-v6-submission":
            description     => "Allow SMTP",
            domain          => "ip6",
            rule            => "&SERVICE_RANGE(tcp, submission, \$SMTP_V6_SOURCES)"
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
