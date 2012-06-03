class bacula-director inherits bacula {

  package {
    "bacula-director-pgsql": ensure => installed;
    "bacula-common": ensure => installed;
    "bacula-common-pgsql": ensure => installed;
  }

  service {
    "bacula-director":
      ensure => running,
      enable => true,
      hasstatus => true,
      require => Package["bacula-director-pgsql"];
  }
  file {
    "/etc/bacula/conf.d":
      ensure  => directory,
      mode => 755,
      group => bacula,
      notify  => Exec["bacula-director restart"]
      ;
    "/etc/bacula/bacula-dir.conf":
      content => template("bacula/etc/bacula/bacula-dir.conf.erb"),
      mode => 440,
      group => bacula,
      require => Package["bacula-director-pgsql"],
      notify  => Exec["bacula-director restart"]
      ;
  }

  exec {
    "bacula-director restart":
      path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
      refreshonly => true;
  }
}
