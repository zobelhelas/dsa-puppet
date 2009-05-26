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
		notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.AF";
		notify no;
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
		notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.AS";
		notify no;
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
		notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.EU";
		notify no;
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
		notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.NA";
		notify no;
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
		notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.SA";
		notify no;
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
		notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.OC";
		notify no;
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
		notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org.AN";
		notify no;
        };
};
view "other" {
        match-clients { any; };
        recursion no;
        zone "security.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org";
		notify no;
        };
        zone "security.geo.debian.org" {
                type master;
                file "/etc/bind/db.security.debian.org";
		notify no;
        };
};
