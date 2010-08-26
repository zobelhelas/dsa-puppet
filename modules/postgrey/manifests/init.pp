class postgrey {
    package { "postgrey": ensure => installed; }

    file {
        "/etc/default/postgrey":
          source  => "puppet:///modules/postgrey/default",
          require => Package["postgrey"],
          notify  => Exec["postgrey restart"]
          ;
    }

    exec { "postgrey restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
