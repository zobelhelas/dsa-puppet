class portforwarder {
    # do not depend on xinetd, yet.  it might uninstall other inetds
    # for now this will have to be done manually
    file {
        "/etc/ssh/userkeys/portforwarder":
            content => template("portforwarder/authorized_keys.erb"),
            mode    => 444,
            ;
        "/etc/xinetd.d":
            ensure  => directory,
            owner   => root,
            group   => root,
            mode    => 755,
            ;
        "/etc/xinetd.d/dsa-portforwader":
            content => template("portforwarder/xinetd.erb"),
            notify  => Exec["xinetd reload"]
            ;
    }

    exec {
        "xinetd reload":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true,
            ;
    }
}
# vim:set et:
# vim:set ts=4:
# vim:set shiftwidth=4:
