class apt-keys {
    file {
        "/etc/apt/trusted-keys.d/":
            ensure  => directory,
            purge   => true,
            notify  => Exec["apt-keys-update"],
            ;

        "/etc/apt/trusted-keys.d/backports.org.asc":
            source  => "puppet:///modules/apt-keys/backports.org.asc",
            mode    => 664,
            notify  => Exec["apt-keys-update"],
            ;
        "/etc/apt/trusted-keys.d/db.debian.org.asc":
            source  => "puppet:///modules/apt-keys/db.debian.org.asc",
            mode    => 664,
            notify  => Exec["apt-keys-update"],
            ;
    }

    exec { "apt-keys-update":
         command => ': && for keyfile in /etc/apt/trusted-keys.d/*; do apt-key add $keyfile; done',
         refreshonly => true
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
