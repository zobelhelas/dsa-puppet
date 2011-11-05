class sudo {
    package { sudo: ensure => installed }

    file {
        "/etc/pam.d/sudo":
            source  => [ "puppet:///modules/sudo/per-host/$fqdn/pam",
                         "puppet:///modules/sudo/common/pam" ],
            require => Package["sudo"],
            ;
    }

    case getfromhash($nodeinfo, 'wheezy') {
        true:  {
            file {
                "/etc/sudoers":
                    owner   => root,
                    group   => root,
                    mode    => 440,
                    source  => [ "puppet:///modules/sudo/common/sudoers",
                    require => Package["sudo"],
                    ;
            }
        }
        default: {
            file {
                "/etc/sudoers":
                    owner   => root,
                    group   => root,
                    mode    => 440,
                    source  => [ "puppet:///modules/sudo/wheezy/sudoers",
                    require => Package["sudo"],
                    ;
            }
        }
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
