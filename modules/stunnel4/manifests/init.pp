class stunnel4 {
    define stunnel_generic($client, $verify, $cafile, $crlfile=false, $accept, $connect, $local=false) {
        file {
            "/etc/stunnel/puppet-${name}.conf":
                content => template("stunnel4/stunnel.conf.erb"),
                notify  => Exec['restart_stunnel'],
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
                rule => "&TCP_UDP_SERVICE(${accept})",
                domain => "(ip ip6)",
                ;
        }
    }
    define stunnel_client($accept, $connecthost, $connectport) {
        file {
            "/etc/stunnel/puppet-${name}-peer.pem":
                # source  => "puppet:///modules/exim/certs/${connecthost}.crt",
                content => generate("/bin/cat", "/etc/puppet/modules/exim/files/certs/${connecthost}.crt",
                                                "/etc/puppet/modules/exim/files/certs/ca.crt"),
                notify  => Exec['restart_stunnel'],
                ;
        }
        stunnel_generic {
            "${name}":
                client => true,
                verify => 3,
                cafile => "/etc/stunnel/puppet-${name}-peer.pem",
                accept => "${accept}",
                connect => "${connecthost}:${connectport}",
                require => [ File["/etc/stunnel/puppet-${name}-peer.pem"] ],
                ;
        }
    }


    package {
        "stunnel4": ensure => installed;
    }

    file {
        "/etc/stunnel/stunnel.conf":
            ensure => absent,
            ;
    }

    exec {
        "enable_stunnel4":
                command => "sed -i -e 's/^ENABLED=/#&/; \$a ENABLED=1 # added by puppet' /etc/default/stunnel4",
                unless => "grep -q '^ENABLED=1' /etc/default/stunnel4",
                require => [ Package['stunnel4'] ],
                ;
        "restart_stunnel":
                command => "env -i /etc/init.d/stunnel4 restart",
                require => [ File['/etc/stunnel/stunnel.conf'], Exec['enable_stunnel4'], Package['stunnel4'] ],
                refreshonly => true,
                ;
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
