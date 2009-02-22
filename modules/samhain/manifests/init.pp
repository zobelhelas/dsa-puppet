class samhain {

    package { samhain: ensure => latest }

    file { "/etc/samhain/samhainrc":
        owner   => root,
        group   => root,
        mode    => 444,
        source  => "puppet:///samhain/samhainrc",
        require => Package["samhain"],
        notify  => Exec["samhain reload"],
    }

    exec { "samhain reload":
        path        => "/etc/init.d/",
        refreshonly => true,
    }
}

