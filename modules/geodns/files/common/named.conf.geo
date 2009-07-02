view "AF" {
        match-clients {
                AF;
        };
        zone "www.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.AF";
                notify no;
        };
        zone "www.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.AF";
                notify no;
        };
        zone "security.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.AF";
                notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.AF";
                notify no;
        };
};

view "AN" {
        match-clients {
                AN;
        };
        zone "www.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.AN";
                notify no;
        };
        zone "www.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.AN";
                notify no;
        };
        zone "security.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.AN";
                notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.AN";
                notify no;
        };
};

view "AS" {
        match-clients {
                AS;
        };
        zone "www.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.AS";
                notify no;
        };
        zone "www.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.AS";
                notify no;
        };
        zone "security.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.AS";
                notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.AS";
                notify no;
        };
};

view "EU" {
        match-clients {
                EU;
        };
        zone "www.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.EU";
                notify no;
        };
        zone "www.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.EU";
                notify no;
        };
        zone "security.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.EU";
                notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.EU";
                notify no;
        };
};

view "NA" {
        match-clients {
                NA;
        };
        zone "www.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.NA";
                notify no;
        };
        zone "www.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.NA";
                notify no;
        };
        zone "security.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.NA";
                notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.NA";
                notify no;
        };
};

view "OC" {
        match-clients {
                OC;
        };
        zone "www.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.OC";
                notify no;
        };
        zone "www.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.OC";
                notify no;
        };
        zone "security.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.OC";
                notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.OC";
                notify no;
        };
};

view "SA" {
        match-clients {
                SA;
        };
        zone "www.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.SA";
                notify no;
        };
        zone "www.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org.SA";
                notify no;
        };
        zone "security.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.SA";
                notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org.SA";
                notify no;
        };
};

view "default" {
        match-clients {
                any;
        };
        zone "www.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org";
                notify no;
        };
        zone "www.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.www.debian.org";
                notify no;
        };
        zone "security.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org";
                notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/geodns/db.security.debian.org";
                notify no;
        };
};

