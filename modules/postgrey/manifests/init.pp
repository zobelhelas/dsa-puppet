class postgrey {
    package { "postgrey": ensure => installed; }

    file {
        "/etc/default/postgrey":
          source  => "puppet:///postgrey/default",
          require => Package["postgrey"],
          notify  => Exec["postgrey restart"]
          ;
    }

    exec { "postgrey restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}
