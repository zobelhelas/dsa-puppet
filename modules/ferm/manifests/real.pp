class ferm::real inherits ferm {

        package { ferm: ensure => installed }

        file { 
                "/etc/ferm/conf.d": 
                        ensure => directory,
                        require => Package["ferm"];
                "/etc/ferm/ferm.conf":
                        source  => "puppet:///ferm/ferm.conf",
                        require => Package["ferm"],
                        mode    => 0400,
                        notify  => Exec["ferm restart"];
                "/etc/ferm/conf.d/me.conf":
                        content => template("ferm/me.conf.erb"),
                        require => Package["ferm"],
                        mode    => 0400,
                        notify  => Exec["ferm restart"];
                "/etc/ferm/conf.d/defs.conf":
                        source  => "puppet:///ferm/defs.conf",
                        require => Package["ferm"],
                        mode    => 0400,
                        notify  => Exec["ferm restart"];
        }

        Exec["ferm restart"] {
                command     => "/etc/init.d/ferm restart",
                refreshonly => true,
        }
}
