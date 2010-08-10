class ferm::per-host {

    case $hostname {
        ancina,zandonai,zelenka: {
           include ferm::zivit
        }
    }
    case $hostname {
        chopin,franck,gluck,kaufmann,kassia,klecker,lobos,merikanto,morricone,raff,ravel,ries,rietz,saens,schein,senfl,stabile,steffani,valente,villa,wieck: {
           include ferm::rsync
        }
    }

    case $hostname {
        chopin,franck,gluck,kassia,klecker,lobos,morricone,ravel,raff,ries,rietz,saens,schein,steffani,valente,villa,wieck: {
           include ferm::ftp
        }
    }

    case $hostname {
        piatti,samosa: {
           @ferm::rule { "dsa-udd-stunnel":
               description  => "port 8080 for udd stunnel",
               rule         => "&SERVICE_RANGE(tcp, http-alt, ( 192.25.206.16 70.103.162.29 217.196.43.134 ))"
           }
        }

        paganini: {
           @ferm::rule { "dsa-dhcp":
		    description     => "Allow dhcp access",
		    rule            => "&SERVICE(udp, 67)"
	   }
           @ferm::rule { "dsa-tftp":
		    description     => "Allow tftp access",
		    rule            => "&SERVICE(udp, 69)"
	   }
        }
        handel: {
	   @ferm::rule { "dsa-puppet":
		    description     => "Allow puppet access",
		    rule            => "&SERVICE_RANGE(tcp, 8140, \$HOST_DEBIAN_V4)"
	   }
	   @ferm::rule { "dsa-puppet-v6":
		    domain          => 'ip6',
		    description     => "Allow puppet access",
		    rule            => "&SERVICE_RANGE(tcp, 8140, \$HOST_DEBIAN_V6)"
	   }
        }
	powell: {
	   @ferm::rule { "dsa-powell-v6-tunnel":
		    description     => "Allow powell to use V6 tunnel broker",
		    rule            => "proto ipv6 saddr 212.227.117.6 jump ACCEPT"
	   }
	   @ferm::rule { "dsa-powell-btseed":
                    domain          => "(ip ip6)",
		    description     => "Allow powell to seed BT",
		    rule            => "proto tcp dport 8000:8100 jump ACCEPT"
	   }
           @ferm::rule { "dsa-powell-rsync":
                    description     => "Hoster wants to sync from here, and why not",
                    rule            => "&SERVICE_RANGE(tcp, rsync, ( 195.20.242.90 192.25.206.33 82.195.75.106 206.12.19.118 ))"
           }
	}
	heininen: {
	   @ferm::rule { "dsa-syslog":
		    description     => "Allow syslog access",
		    rule            => "&SERVICE_RANGE(tcp, 5140, \$HOST_DEBIAN_V4)"
	   }
	   @ferm::rule { "dsa-syslog-v6":
		    domain          => 'ip6',
		    description     => "Allow syslog access",
		    rule            => "&SERVICE_RANGE(tcp, 5140, \$HOST_DEBIAN_V6)"
	   }
        }
	kaufmann: {
           @ferm::rule { "dsa-hkp":
		    domain          => "(ip ip6)",
		    description     => "Allow hkp access",
		    rule            => "&SERVICE(tcp, 11371)"
           }
	}
	liszt: {
           @ferm::rule { "smtp":
		    domain          => "(ip ip6)",
		    description     => "Allow smtp access",
		    rule            => "&SERVICE(tcp, 25)"
           }
        }
	draghi: {
            @ferm::rule { "dsa-bind":
                    domain          => "(ip ip6)",
                    description     => "Allow nameserver access",
                    rule            => "&TCP_UDP_SERVICE(53)"
            }
            @ferm::rule { "dsa-finger":
                    domain          => "(ip ip6)",
                    description     => "Allow finger access",
                    rule            => "&SERVICE(tcp, 79)"
	    }
            @ferm::rule { "dsa-ldap":
                    domain          => "(ip ip6)",
                    description     => "Allow ldap access",
                    rule            => "&SERVICE(tcp, 389)"
	    }
            @ferm::rule { "dsa-ldaps":
                    domain          => "(ip ip6)",
                    description     => "Allow ldaps access",
                    rule            => "&SERVICE(tcp, 636)"
	    }
        }
    }
}
