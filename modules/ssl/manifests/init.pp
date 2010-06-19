class ssl {
    package { openssl: ensure => installed }

    file {
        "/etc/ssl/debian":
          ensure  => directory,
          mode    => 755,
          purge   => true,
          recurse => true,
          force   => true,
          source  => "puppet:///files/empty/"
        ;
        "/etc/ssl/debian/certs":
          ensure  => directory,
          mode    => 755,
          purge   => true,
          force   => true,
          recurse => true,
          source  => "puppet:///files/empty/"
        ;
        "/etc/ssl/debian/crls":
          ensure  => directory,
          mode    => 755,
          purge   => true,
          force   => true,
          recurse => true,
          source  => "puppet:///files/empty/"
        ;
        "/etc/ssl/debian/keys":
          ensure  => directory,
          mode    => 750,
          purge   => true,
          force   => true,
          recurse => true,
          source  => "puppet:///files/empty/"
        ;
        "/etc/ssl/debian/certs/thishost.crt":
          source  => "puppet:///ssl/clientcerts/$fqdn.client.crt",
          notify  => Exec["c_rehash /etc/ssl/debian/certs"],
          ;
        "/etc/ssl/debian/keys/thishost.key":
          source  => "puppet:///ssl/clientcerts/$fqdn.key",
          mode    => 640
          ;
        "/etc/ssl/debian/certs/ca.crt":
          source  => "puppet:///ssl/clientcerts/ca.crt",
          notify  => Exec["c_rehash /etc/ssl/debian/certs"],
          ;
        "/etc/ssl/debian/crls/ca.crl":
          source  => "puppet:///ssl/clientcerts/ca.crl",
          ;
    }

    exec { "c_rehash /etc/ssl/debian/certs":
        refreshonly => true,
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
