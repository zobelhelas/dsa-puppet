class samhain {

    package { samhain: ensure => installed }

    file { "/etc/samhain/samhainrc":
        content => template("samhain/samhainrc.erb"),
        require => Package["samhain"],
        notify  => Exec["samhain reload"],
    }

    exec { "samhain reload":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:

