class nfs-server {

    include ferm::nfs-server

    package {
        nfs-common: ensure => installed;
        nfs-kernel-server: ensure => installed;
    }

    file {
        "/etc/default/nfs-common":
            source  => "puppet:///modules/nfs-server/nfs-common.default",
            require => Package["nfs-common"],
            notify  => Exec["nfs-common restart"];
        "/etc/default/nfs-kernel-server":
            source  => "puppet:///modules/nfs-server/nfs-kernel-server.default",
            require => Package["nfs-kernel-server"],
            notify  => Exec["nfs-kernel-server restart"];
        "/etc/modprobe.d/lockd.local":
            source  => "puppet:///modules/nfs-server/lockd.local.modprobe";
    }

    exec {
        "nfs-common restart":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true;
        "nfs-kernel-server restart":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true;
    }
}
