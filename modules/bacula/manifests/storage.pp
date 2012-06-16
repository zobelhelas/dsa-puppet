class bacula::storage inherits bacula {

  package {
    "bacula-sd": ensure => installed;
  }

  service {
    "bacula-sd":
      ensure => running,
      enable => true,
      hasstatus => true,
      ;
  }
  file {
    "/etc/bacula/bacula-sd.conf":
      content => template("bacula/bacula-sd.conf.erb"),
      mode => 640,
      group => bacula,
      notify  => Exec["bacula-sd restart"]
      ;
  }

  exec {
    "bacula-sd restart":
      path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
      refreshonly => true;
  }
}
