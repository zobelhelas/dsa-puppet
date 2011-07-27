class stunnel4 {
    define stunnel_generic($client, $verify, $cafile, $crlfile=false, $accept, $connect, $local=false) {
        file {
            "/etc/stunnel":
                ensure  => directory,
                owner   => root,
                group   => root,
                mode    => 755,
                ;
            "/etc/stunnel/puppet-${name}.conf":
                content => template("stunnel4/stunnel.conf.erb"),
                notify  => Exec["restart_stunnel_${name}"],
                ;
            "/etc/init.d/stunnel4":
                source => "puppet:///modules/stunnel4/etc-init.d-stunnel4",
                mode    => 555,
            ;
        }

        case $client {
                true: {
                    $certfile = "/etc/ssl/debian/certs/thishost.crt"
                    $keyfile = "/etc/ssl/debian/keys/thishost.key"
                    }
                default: {
                    $certfile = "/etc/exim4/ssl/thishost.crt"
                    $keyfile = "/etc/exim4/ssl/thishost.key"
                    }
        }

        exec {
            "restart_stunnel_${name}":
                    command => "true && cd / && env -i /etc/init.d/stunnel4 restart puppet-${name}",
                    require => [ File['/etc/stunnel/stunnel.conf'],
                                 File['/etc/init.d/stunnel4'],
                                 Exec['enable_stunnel4'],
                                 Exec['kill_file_override'],
                                 Package['stunnel4']
                               ],
                    subscribe => [ File[$certfile],
                                   File[$keyfile]
                                 ],
                    refreshonly => true,
                    ;
        }
    }

    # define an stunnel listener, listening for SSL connections on $accept,
    # connecting to plaintext service $connect using local source address $local
    #
    # unfortunately stunnel is really bad about verifying its peer,
    # all we can be certain of is that they are signed by our CA,
    # not who they are.  So do not use in places where the identity of
    # the caller is important.  Use dsa-portforwarder for that.
    define stunnel_server($accept, $connect, $local = "127.0.0.1") {
        stunnel_generic {
            "${name}":
                client => false,
                verify => 2,
                cafile => "/etc/exim4/ssl/ca.crt",
                crlfile => "/etc/exim4/ssl/crl.crt",
                accept => "${accept}",
                connect => "${connect}",
                ;
        }
        @ferm::rule {
            "stunnel-${name}":
                description => "stunnel ${name}",
                rule => "&SERVICE_RANGE(tcp, ${accept}, \$HOST_DEBIAN_V4)",
                ;
            "stunnel-${name}-v6":
                domain          => 'ip6',
                description => "stunnel ${name}",
                rule => "&SERVICE_RANGE(tcp, ${accept}, \$HOST_DEBIAN_V6)",
                ;
        }
    }
    define stunnel_client($accept, $connecthost, $connectport) {
        file {
            "/etc/stunnel/puppet-${name}-peer.pem":
                # source  => "puppet:///modules/exim/certs/${connecthost}.crt",
                content => generate("/bin/cat", "/etc/puppet/modules/exim/files/certs/${connecthost}.crt",
                                                "/etc/puppet/modules/exim/files/certs/ca.crt"),
                notify  => Exec["restart_stunnel_${name}"],
                ;
        }
        stunnel_generic {
            "${name}":
                client => true,
                verify => 3,
                cafile => "/etc/stunnel/puppet-${name}-peer.pem",
                accept => "${accept}",
                connect => "${connecthost}:${connectport}",
                ;
        }
    }


    package {
        "stunnel4": ensure => installed;
    }

    file {
        "/etc/stunnel/stunnel.conf":
            ensure => absent,
            require => [ Package['stunnel4'] ],
            ;
    }

    exec {
        "enable_stunnel4":
                command => "sed -i -e 's/^ENABLED=/#&/; \$a ENABLED=1 # added by puppet' /etc/default/stunnel4",
                unless => "grep -q '^ENABLED=1' /etc/default/stunnel4",
                require => [ Package['stunnel4'] ],
                ;
        "kill_file_override":
                command => "sed -i -e 's/^FILES=/#&/' /etc/default/stunnel4",
                onlyif => "grep -q '^FILES=' /etc/default/stunnel4",
                require => [ Package['stunnel4'] ],
                ;
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
