class clamav {
    package { "clamav-daemon": ensure => installed;
              "clamav-freshclam": ensure => installed;
              "clamav-unofficial-sigs": ensure => installed;
    }
}

