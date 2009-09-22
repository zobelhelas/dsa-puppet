class buildd {
   package {
     "sbuild": ensure => installed;
     "buildd": ensure => installed;
     "buildd-builder-meta": ensure => installed;
     "apt-transport-https": ensure => installed;
     "debootstrap": ensure => installed;
   }

   file {
      "/etc/apt/sources.list.d/buildd.list":
             source  => template("buildd/etc/apt/sources.list.d/buildd.list.erb"),
             require => Package["apt-transport-https"],
             notify  => Exec["apt-get update"],
             ;

      "/etc/apt/trusted-keys.d/buildd.debian.org.asc":
            source  => "puppet:///buildd/buildd.debian.org.asc",
            mode    => 664,
            notify  => Exec["apt-keys-update"],
            ;
      "/etc/schroot/mount-defaults":
            source  => "puppet:///buildd/mount-defaults",
            require => Package["sbuild"]
            ;
   }
}
