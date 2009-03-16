class samhain {

    package { samhain: ensure => installed }

    file { "/etc/samhain/samhainrc":
        source  => [ "puppet:///samhain/per-host/$fqdn/samhainrc",
                     "puppet:///samhain/common/samhainrc" ],
        require => Package["samhain"],
        notify  => Exec["samhain reload"],
    }

    exec { "samhain reload":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}

