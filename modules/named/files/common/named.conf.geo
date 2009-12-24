// This file was created by dsa-geodomains/zonebuilder --create-named-conf
// and is distributed to hosts using puppet as
// dsa-puppet/modules/geodns/files/common/named.conf.geo
// you probably do not want to edit it manually wherever you find it

view "AF" {
  match-clients { AF; };

  zone "volatile.debian.org" {
    type master;
    file "/etc/bind/geodns/db.volatile.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.geo.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/db.ftp.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/db.bugs.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/db.www.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/db.packages.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "AN" {
  match-clients { AN; };

  zone "volatile.debian.org" {
    type master;
    file "/etc/bind/geodns/db.volatile.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.geo.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/db.ftp.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/db.bugs.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/db.www.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/db.packages.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "AS" {
  match-clients { AS; };

  zone "volatile.debian.org" {
    type master;
    file "/etc/bind/geodns/db.volatile.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.geo.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/db.ftp.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/db.bugs.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/db.www.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/db.packages.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "EU" {
  match-clients { EU; };

  zone "volatile.debian.org" {
    type master;
    file "/etc/bind/geodns/db.volatile.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.geo.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/db.ftp.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/db.bugs.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/db.www.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/db.packages.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "NA" {
  match-clients { NA; };

  zone "volatile.debian.org" {
    type master;
    file "/etc/bind/geodns/db.volatile.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.geo.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/db.ftp.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/db.bugs.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/db.www.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/db.packages.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "OC" {
  match-clients { OC; };

  zone "volatile.debian.org" {
    type master;
    file "/etc/bind/geodns/db.volatile.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.geo.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/db.ftp.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/db.bugs.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/db.www.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/db.packages.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "SA" {
  match-clients { SA; };

  zone "volatile.debian.org" {
    type master;
    file "/etc/bind/geodns/db.volatile.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.geo.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/db.ftp.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/db.bugs.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/db.www.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/db.packages.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "default" {
  match-clients { any; };

  zone "volatile.debian.org" {
    type master;
    file "/etc/bind/geodns/db.volatile.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.geo.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/db.security.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/db.ftp.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/db.bugs.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/db.www.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/db.packages.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
