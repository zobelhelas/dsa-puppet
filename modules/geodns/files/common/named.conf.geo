// This file was created by dsa-geodomains/zonebuilder --create-named-conf
// and is distributed to hosts using puppet as
// dsa-puppet/modules/geodns/files/common/named.conf.geo
// you probably do not want to edit it manually wherever you find it

view "AF" {
  match-clients { AF; };
  zone "security.geo.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.AF"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "security.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.AF"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.geo.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.AF"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.AF"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "packages.debian.org" { type master; file "/etc/bind/geodns/db.packages.debian.org.AF"; notify no; allow-query { any; }; allow-transfer { }; };
};
view "AN" {
  match-clients { AN; };
  zone "security.geo.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.AN"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "security.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.AN"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.geo.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.AN"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.AN"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "packages.debian.org" { type master; file "/etc/bind/geodns/db.packages.debian.org.AN"; notify no; allow-query { any; }; allow-transfer { }; };
};
view "AS" {
  match-clients { AS; };
  zone "security.geo.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.AS"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "security.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.AS"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.geo.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.AS"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.AS"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "packages.debian.org" { type master; file "/etc/bind/geodns/db.packages.debian.org.AS"; notify no; allow-query { any; }; allow-transfer { }; };
};
view "EU" {
  match-clients { EU; };
  zone "security.geo.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.EU"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "security.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.EU"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.geo.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.EU"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.EU"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "packages.debian.org" { type master; file "/etc/bind/geodns/db.packages.debian.org.EU"; notify no; allow-query { any; }; allow-transfer { }; };
};
view "NA" {
  match-clients { NA; };
  zone "security.geo.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.NA"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "security.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.NA"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.geo.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.NA"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.NA"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "packages.debian.org" { type master; file "/etc/bind/geodns/db.packages.debian.org.NA"; notify no; allow-query { any; }; allow-transfer { }; };
};
view "OC" {
  match-clients { OC; };
  zone "security.geo.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.OC"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "security.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.OC"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.geo.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.OC"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.OC"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "packages.debian.org" { type master; file "/etc/bind/geodns/db.packages.debian.org.OC"; notify no; allow-query { any; }; allow-transfer { }; };
};
view "SA" {
  match-clients { SA; };
  zone "security.geo.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.SA"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "security.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org.SA"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.geo.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.SA"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org.SA"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "packages.debian.org" { type master; file "/etc/bind/geodns/db.packages.debian.org.SA"; notify no; allow-query { any; }; allow-transfer { }; };
};
view "default" {
  match-clients { any; };
  zone "security.geo.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "security.debian.org" { type master; file "/etc/bind/geodns/db.security.debian.org"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.geo.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "www.debian.org" { type master; file "/etc/bind/geodns/db.www.debian.org"; notify no; allow-query { any; }; allow-transfer { }; };
  zone "packages.debian.org" { type master; file "/etc/bind/geodns/db.packages.debian.org"; notify no; allow-query { any; }; allow-transfer { }; };
};
