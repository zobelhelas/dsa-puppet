class exim::mx inherits exim {
    file {
        "/etc/exim4/ccTLD.txt":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/common/ccTLD.txt" ]
          ;
        "/etc/exim4/surbl_whitelist.txt":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/common/surbl_whitelist.txt" ]
          ;
        "/etc/exim4/exim_surbl.pl":
          require => Package["exim4-daemon-heavy"],
          source  => [ "puppet:///exim/common/exim_surbl.pl" ],
          notify  => Exec["exim4 restart"]
          ;
    }
    exec { "exim4 restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}

