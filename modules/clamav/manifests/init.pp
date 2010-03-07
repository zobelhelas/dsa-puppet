class clamav {
    package {
        "clamav-daemon": ensure => installed;
        "clamav-freshclam": ensure => installed;
        "clamav-unofficial-sigs": ensure => installed;
    }
    file {
        "/etc/clamav-unofficial-sigs.dsa.conf":
            require => Package["clamav-unofficial-sigs"],
            source  => [ "puppet:///clamav/clamav-unofficial-sigs.dsa.conf" ]
            ;
        "/etc/clamav-unofficial-sigs.conf":
            require => Package["clamav-unofficial-sigs"],
            source  => [ "puppet:///clamav/clamav-unofficial-sigs.conf" ]
            ;
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
