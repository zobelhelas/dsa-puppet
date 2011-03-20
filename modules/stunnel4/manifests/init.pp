class stunnel4 {
    # define an stunnel listener, listening for SSL connections on $accept,
    # connecting to plaintext service $connect using local source address $local
    define stunnel_server($accept, $connect, $local = "127.0.0.1") {
        file {
            "/etc/stunnel/puppet-${name}.conf":
                content => template("stunnel4/server.conf.erb"),
                notify  => Exec['restart_stunnel'],
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
                ;
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
