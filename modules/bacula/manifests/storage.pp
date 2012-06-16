class bacula::storage inherits bacula {

  package {
    "bacula-sd": ensure => installed;
    "bacula-sd-pgsql": ensure => installed;
  }

  service {
    "bacula-sd":
      ensure => running,
      enable => true,
      hasstatus => true,
      require => Package["bacula-sd-pgsql"];
  }
  file {
    "/etc/bacula/bacula-sd.conf":
      content => template("bacula/bacula-sd.conf.erb"),
      mode => 640,
      group => bacula,
      require => Package["bacula-sd-pgsql"],
      notify  => Exec["bacula-sd restart"]
      ;
  }

  exec {
    "bacula-sd restart":
      path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
      refreshonly => true;
  }
}
