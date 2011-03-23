class entropykey::provider {
    package {
        "ekeyd": ensure => installed;
    }

    file {
        "/etc/entropykey/ekeyd.conf":
            source => "puppet:///modules/entropykey/ekeyd.conf",
            notify  => Exec['restart_ekeyd'],
            require => [ Package['ekeyd'] ],
        ;
    }

    exec {
        "restart_ekeyd":
                command => "true && cd / && env -i /etc/init.d/ekeyd restart",
                require => [ File['/etc/entropykey/ekeyd.conf'] ],
                refreshonly => true,
                ;
    }

    include "stunnel4"
    stunnel4::stunnel_server {
        "ekeyd":
            accept => 18888,
            connect => "127.0.0.1:8888",
            ;
    }
}

class entropykey::local_consumer {
    package {
        "ekeyd-egd-linux": ensure => installed;
    }

    file {
        "/etc/default/ekeyd-egd-linux":
            source => "puppet:///modules/entropykey/ekeyd-egd-linux",
            notify  => Exec['restart_ekeyd-egd-linux'],
            require => [ Package['ekeyd-egd-linux'] ],
        ;
    }

    exec {
        "restart_ekeyd-egd-linux":
                command => "true && cd / && env -i /etc/init.d/ekeyd-egd-linux restart",
                require => [ File['/etc/default/ekeyd-egd-linux'] ],
                refreshonly => true,
                ;
    }
}

class entropykey::remote_consumer inherits entropykey::local_consumer {
    include "stunnel4"
    stunnel4::stunnel_client {
        "ekeyd":
            accept => "127.0.0.1:8888",
            connecthost => "${entropy_provider}",
            connectport => 18888,
            ;
    }
}

class entropykey {
    case getfromhash($nodeinfo, 'entropy_key') {
        true:  { include entropykey::provider }
    }

    $entropy_provider  = entropy_provider($fqdn, $nodeinfo)
    case $entropy_provider {
        false: {}
        local: { include entropykey::local_consumer }
        default: { include entropykey::remote_consumer }
    }

}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
