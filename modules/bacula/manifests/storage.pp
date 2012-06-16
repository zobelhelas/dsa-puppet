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

  @ferm::rule { 'dsa-bacula-sd-v4':
    domain      => '(ip)',
    description => 'Allow bacula-sd access from director and clients',

    rule            => 'proto tcp mod state state (NEW) dport (bacula-sd) @subchain \'bacula-sd\' { saddr ($HOST_DEBIAN_V4) ACCEPT; }',
  }
  @ferm::rule { 'dsa-bacula-sd-v6':
    domain      => '(ip6)',
    description => 'Allow bacula-sd access from director and clients',

    rule            => 'proto tcp mod state state (NEW) dport (bacula-sd) @subchain \'bacula-sd\' { saddr ($HOST_DEBIAN_V6) ACCEPT; }',

}
