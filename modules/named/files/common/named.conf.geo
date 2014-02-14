// This file was created by auto-dns/build-zones --create-named-conf
// and is distributed to hosts using puppet as
// dsa-puppet/modules/geodns/files/common/named.conf.geo
// you probably do not want to edit it manually wherever you find it

view "AF" {
  match-clients { AF; };

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.AF";
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

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.AN";
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

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.AS";
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

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.EU";
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

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.NA";
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

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.OC";
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

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.SA";
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

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org.undef";
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

  zone "security.debian.org" {
    type master;
    file "/etc/bind/geodns/zonefiles/db.security.debian.org";
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
