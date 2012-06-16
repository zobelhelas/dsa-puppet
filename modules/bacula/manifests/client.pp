class bacula::client inherits bacula {

  package {
    "bacula-client": ensure => installed;
    "bacula-fd": ensure => installed;
  }

  service {
    "bacula-fd":
      ensure => running,
      enable => true,
      hasstatus => true,
      require => Package["bacula-fd"];
  }

  file {
    "/etc/bacula/bacula-fd.conf":
      content => template("bacula/bacula-fd.conf.erb"),
      mode => 640,
      owner => root,
      group => bacula,
      require => Package["bacula-fd"],
      notify  => Exec["bacula-fd restart"]
      ;
  }

  exec {
    "bacula-fd restart":
      path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
      refreshonly => true;
  }
}
