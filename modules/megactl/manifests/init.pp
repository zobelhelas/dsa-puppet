class megactl {
    package {
        megactl: ensure => installed;
    }
    file {
        "/etc/apt/sources.list.d/debian.restricted.list":
            content => template("debian-org/etc/apt/sources.list.d/debian.restricted.list.erb"),
            notify  => Exec["apt-get update"];
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
