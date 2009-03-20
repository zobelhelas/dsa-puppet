class clamav {
    package { "clamav-daemon": ensure => latest;
              "clamav-freshclam": ensure => latest;
    }

    file {
        "/etc/clamav/clamd.conf":
          source  => "puppet:///clamav/clamd.conf",
          require => Package["clamav-daemon"],
          notify  => Exec["clamav-daemon restart"]
          ;
    }

    file {
        "/etc/clamav/freshclam.conf":
          source  => "puppet:///clamav/freshclam.conf",
          require => Package["clamav-freshclam"],
          notify  => Exec["clamav-freshclam restart"]
          ;
    }
    exec { "clamav-daemon restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
    exec { "clamav-freshclam restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}

