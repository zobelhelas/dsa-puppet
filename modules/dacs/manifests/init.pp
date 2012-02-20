class dacs {
    package {
        "dacs": ensure => installed;
        "libapache2-mod-dacs": ensure => installed;
    }

    file {
        "/var/log/dacs":
             ensure  => directory,
             owner   => root
             group   => www-data,
             mode    => 770,
             purge   => true
             ;
        "/etc/dacs/federations":
             require => Package["libapache2-mod-dacs"],
             ensure  => directory,
             owner   => root,
             group   => www-data,
             mode    => 750,
             purge   => true
             ;

        "/etc/dacs/federations/debian.org/":
             require => Package["libapache2-mod-dacs"],
             ensure  => directory,
             owner   => root,
             group   => www-data,
             mode    => 750,
             purge   => true
             ;

        "/etc/dacs/federations/debian.org/DEBIAN":
             require => Package["libapache2-mod-dacs"],
             ensure  => directory,
             owner   => root,
             group   => www-data,
             mode    => 750,
             purge   => true
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/acls":
             require => Package["libapache2-mod-dacs"],
             ensure  => directory,
             owner   => root,
             group   => www-data,
             mode    => 750,
             purge   => true
             ;
        
        "/etc/dacs/federations/debian.org/DEBIAN/groups":
             require => Package["libapache2-mod-dacs"],
             ensure  => directory,
             owner   => root,
             group   => www-data,
             mode    => 750,
             purge   => true
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/groups/DACS":
             require => Package["libapache2-mod-dacs"],
             ensure  => directory,
             owner   => root,
             group   => www-data,
             mode    => 750,
             purge   => true
             ;

        "/etc/dacs/federations/site.conf":
             require => Package["libapache2-mod-dacs"],
             source  => [ "puppet:///modules/dacs/per-host/$fqdn/site.conf",
                          "puppet:///modules/dacs/common/site.conf" ],
             mode    => 640,
             owner   => root,
             group   => www-data
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/dacs.conf":
             require => Package["libapache2-mod-dacs"],
             source  => [ "puppet:///modules/dacs/per-host/$fqdn/dacs.conf",
                          "puppet:///modules/dacs/common/dacs.conf" ],
             mode    => 640,
             owner   => root,
             group   => www-data
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/acls/revocations":
             require => Package["libapache2-mod-dacs"],
             source  => [ "puppet:///modules/dacs/per-host/$fqdn/revocations",
                          "puppet:///modules/dacs/common/revocations" ],
             mode    => 640,
             owner   => root,
             group   => www-data
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/groups/DACS/jurisdictions.grp":
             require => Package["libapache2-mod-dacs"],
             source  => [ "puppet:///modules/dacs/per-host/$fqdn/jurisdictions.grp",
                          "puppet:///modules/dacs/common/jurisdictions.grp" ],
             mode    => 640,
             owner   => root,
             group   => www-data
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/acls/acl-noauth.0":
             require => Package["libapache2-mod-dacs"],
             source  => [ "puppet:///modules/dacs/per-host/$fqdn/acl-noauth.0",
                          "puppet:///modules/dacs/common/acl-noauth.0" ],
             mode    => 640,
             owner   => root,
             group   => www-data,
             notify  => Exec["dacsacl"]
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/acls/acl-private.0":
             require => Package["libapache2-mod-dacs"],
             source  => [ "puppet:///modules/dacs/per-host/$fqdn/acl-private.0",
                          "puppet:///modules/dacs/common/acl-private.0" ],
             mode    => 640,
             owner   => root,
             group   => www-data,
             notify  => Exec["dacsacl"]
             ;

        "/etc/dacs/federations/debian.org/federation_keyfile":
             require => Package["libapache2-mod-dacs"],
             source  => "puppet:///modules/dacs/private/debian.org_federation_keyfile",
             mode    => 640,
             owner   => root,
             group   => www-data
             ;

        "/etc/dacs/federations/debian.org/DEBIAN/jurisdiction_keyfile":
             require => Package["libapache2-mod-dacs"],
             source  => "puppet:///modules/dacs/private/DEBIAN_jurisdiction_keyfile",
             mode    => 640,
             owner   => root,
             group   => www-data
             ;

    }

    exec {
        "dacsacl":
            command     => "dacsacl -sc /etc/dacs/federations/site.conf -c /etc/dacs/federations/debian.org/DEBIAN/dacs.conf -uj DEBIAN && chown root:www-data /etc/dacs/federations/debian.org/DEBIAN/acls/INDEX",
            refreshonly => true,
    }


}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
