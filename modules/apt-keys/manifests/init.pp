class apt-keys {
    file {
        "/etc/apt/trusted-keys.d/":
          ensure  => directory,
          purge   => true,
          notify  => Exec["updatekeys"],
          ;

        "/etc/apt/trusted-keys.d/db.debian.org.asc":
          source  => "puppet:///apt-keys/db.debian.org.asc",
          mode    => 664,
          notify  => Exec["updatekeys"],
          ;
    }

    exec { "updatekeys":
         command => 'for keyfile in /etc/apt/trusted-keys.d/*; do apt-key add $keyfile; done',
         refreshonly => true
    }
}

