//
// THIS FILE IS UNDER PUPPET CONTROL. DON'T EDIT IT HERE.
// USE: git clone git+ssh://$USER@puppet.debian.org/srv/puppet.debian.org/git/dsa-puppet.git
//

view 'Africa' {
	match-clients {
		Africa;
        };
        recursion no;
        zone "security.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.AF";
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.AF";
        };
};

view 'Asia' {
	match-clients {
		Asia;
        };
        recursion no;
        zone "security.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.AS";
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.AS";
        };
};

view 'Europe' {
	match-clients { 
		Europe; 
	};
        recursion no;
        zone "security.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.EU";
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.EU";
        };
};

view 'NorthAmerica' {
	match-clients {
		NorthAmerica;
        };
        recursion no;
        zone "security.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.NA";
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.NA";
        };
};
view 'SouthAmerica' {
	match-clients {
		SouthAmerica;
        };
        recursion no;
        zone "security.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.SA";
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.SA";
        };
};
view 'Oceania' {
	match-clients {
		Oceania;
        };
        recursion no;
        zone "security.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.OC";
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.OC";
        };
};
view 'Antarctica' {
	match-clients {
		Antarctica;
        };
        recursion no;
        zone "security.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.AN";
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.AN";
        };
};
view "other" {
        match-clients { any; };
        recursion no;
        zone "security.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org";
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org";
        };
};
