class dacs {
    package {
        "dacs": ensure => installed;
        "libapache2-mod-dacs": ensure => installed;
    }

    file {
        "/etc/dacs/federations":
             ensure  => directory,
             owner   => root,
             group   => www-data,
             mode    => 750,
             purge   => true
             ;

        "/etc/dacs/federations/debian.org/":
             ensure  => directory,
             owner   => root,
             group   => www-data,
             mode    => 750,
             purge   => true
             ;

        "/etc/dacs/federations/debian.org/DEBIAN":
             ensure  => directory,
             owner   => root,
             group   => www-data,
             mode    => 750,
             purge   => true
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/acls":
             ensure  => directory,
             owner   => root,
             group   => www-data,
             mode    => 750,
             purge   => true
             ;
        
        "/etc/dacs/federations/debian.org/DEBIAN/groups":
             ensure  => directory,
             owner   => root,
             group   => www-data,
             mode    => 750,
             purge   => true
             ;

        "/etc/dacs/federations/site.conf":
             source  => [ "puppet:///modules/dacs/per-host/$fqdn/site.conf",
                          "puppet:///modules/dacs/common/site.conf" ],
             mode    => 640,
             owner   => root,
             group   => www-data
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/dacs.conf":
             source  => [ "puppet:///modules/dacs/per-host/$fqdn/dacs.conf",
                          "puppet:///modules/dacs/common/dacs.conf" ],
             mode    => 640,
             owner   => root,
             group   => www-data
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/acls/revocations":
             source  => [ "puppet:///modules/dacs/per-host/$fqdn/revocations",
                          "puppet:///modules/dacs/common/revocations" ],
             mode    => 640,
             owner   => root,
             group   => www-data
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/acls/acl-noauth.0":
             source  => [ "puppet:///modules/dacs/per-host/$fqdn/acl-noauth.0",
                          "puppet:///modules/dacs/common/acl-noauth.0" ],
             mode    => 640,
             owner   => root,
             group   => www-data
             notify  => Exec["dacsacl"]
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/acls/acl-private.0":
             source  => [ "puppet:///modules/dacs/per-host/$fqdn/acl-private.0",
                          "puppet:///modules/dacs/common/acl-private.0" ],
             mode    => 640,
             owner   => root,
             group   => www-data
             notify  => Exec["dacsacl"]
             ;
    }

    exec {
        "dacsacl":
            command     => "dacsacl -uj DEBIAN",
            refreshonly => true,
    }


}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
