// This file was created by dsa-geodomains/zonebuilder --create-named-conf
// and is distributed to hosts using puppet as
// dsa-puppet/modules/geodns/files/common/named.conf.geo
// you probably do not want to edit it manually wherever you find it

view "AF" {
  match-clients { AF; };

  zone "archive.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.archive.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "backports.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.backports.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.bugs.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp-upcoming.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp-upcoming.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.packages.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "snapshot.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.snapshot.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "static.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.static.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.www.debian.org.AF";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "AN" {
  match-clients { AN; };

  zone "archive.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.archive.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "backports.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.backports.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.bugs.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp-upcoming.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp-upcoming.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.packages.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "snapshot.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.snapshot.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "static.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.static.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.www.debian.org.AN";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "AS" {
  match-clients { AS; };

  zone "archive.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.archive.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "backports.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.backports.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.bugs.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp-upcoming.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp-upcoming.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.packages.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "snapshot.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.snapshot.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "static.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.static.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.www.debian.org.AS";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "EU" {
  match-clients { EU; };

  zone "archive.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.archive.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "backports.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.backports.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.bugs.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp-upcoming.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp-upcoming.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.packages.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "snapshot.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.snapshot.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "static.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.static.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.www.debian.org.EU";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "NA" {
  match-clients { NA; };

  zone "archive.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.archive.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "backports.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.backports.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.bugs.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp-upcoming.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp-upcoming.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.packages.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "snapshot.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.snapshot.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "static.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.static.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.www.debian.org.NA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "OC" {
  match-clients { OC; };

  zone "archive.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.archive.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "backports.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.backports.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.bugs.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp-upcoming.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp-upcoming.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.packages.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "snapshot.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.snapshot.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "static.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.static.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.www.debian.org.OC";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "SA" {
  match-clients { SA; };

  zone "archive.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.archive.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "backports.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.backports.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.bugs.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp-upcoming.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp-upcoming.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.packages.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "snapshot.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.snapshot.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "static.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.static.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.www.debian.org.SA";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "undef" {
  match-clients { undef; };

  zone "archive.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.archive.debian.org.undef";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "backports.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.backports.debian.org.undef";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.bugs.debian.org.undef";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp-upcoming.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp-upcoming.debian.org.undef";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp.debian.org.undef";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.packages.debian.org.undef";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.undef";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "snapshot.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.snapshot.debian.org.undef";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "static.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.static.debian.org.undef";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.www.debian.org.undef";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
view "default" {
  match-clients { any; };

  zone "archive.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.archive.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "backports.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.backports.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "bugs.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.bugs.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp-upcoming.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp-upcoming.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "ftp.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.ftp.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "packages.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.packages.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "snapshot.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.snapshot.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "static.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.static.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

  zone "www.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.www.debian.org";
    notify no;
    allow-query { any; };
    allow-transfer { };
  };

};
