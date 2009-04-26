class buildd {
   package {
     "sbuild": ensure => latest;
     "buildd": ensure => latest;
     "buildd-builder-meta": ensure => latest;
     "apt-transport-https": ensure => installed;
     "debootstrap": ensure => installed;
   }

   file {
      "/etc/apt/sources.list.d/buildd.list":
             source => "puppet:///files/etc/apt/sources.list.d/buildd.list",
             require => Package["apt-transport-https"]
             ;

        "/etc/apt/trusted-keys.d/buildd.debian.org.asc":
          source  => "puppet:///buildd/buildd.debian.org.asc",
          mode    => 664,
          notify  => Exec["updatekeys"],
          ;
   }
}
