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
	cilea: {
            file {
                "/etc/ferm/conf.d/load_sip_conntrack.conf":
                    source => "puppet:///ferm/conntrack_sip.conf",
                    require => Package["ferm"],
                    notify  => Exec["ferm restart"];
            }
            @ferm::rule { "dsa-sip":
                    domain          => "(ip ip6)",
                    description     => "Allow sip access",
                    rule            => "&TCP_UDP_SERVICE(5060)"
            }
            @ferm::rule { "dsa-sipx":
                    domain          => "(ip ip6)",
                    description     => "Allow sipx access",
                    rule            => "&TCP_UDP_SERVICE(5080)"
            }
        }
    }




    case $hostname { rautavaara,luchesi: {
        @ferm::rule { "dsa-to-kfreebsd":
            description     => "Traffic routed to kfreebsd hosts",
            chain           => 'to-kfreebsd',
            rule            => 'proto icmp ACCEPT;
                                source ($FREEBSD_SSH_ACCESS $HOST_NAGIOS_V4) proto tcp dport 22 ACCEPT;
                                source ($HOST_MAILRELAY_V4 $HOST_NAGIOS_V4) proto tcp dport 25 ACCEPT;
                                source ($HOST_MUNIN_V4 $HOST_NAGIOS_V4) proto tcp dport 4949 ACCEPT;
                                source ($HOST_NAGIOS_V4) proto tcp dport 5666 ACCEPT;
                                source ($HOST_NAGIOS_V4) proto udp dport ntp ACCEPT;
                               '
        }
        @ferm::rule { "dsa-from-kfreebsd":
            description     => "Traffic routed from kfreebsd vlan/bridge",
            chain           => 'from-kfreebsd',
            rule            => 'proto icmp ACCEPT;
                                proto tcp dport (21 22 80 53 443) ACCEPT;
                                proto udp dport (53 123) ACCEPT;
                                proto tcp dport 8140 daddr 82.195.75.104 ACCEPT; # puppethost
                                proto tcp dport 5140 daddr 82.195.75.98 ACCEPT; # loghost
                                proto tcp dport (25 submission) daddr ($HOST_MAILRELAY_V4) ACCEPT;
                               '
        }
    }}
    case $hostname {
        rautavaara: {
            @ferm::rule { "dsa-routing":
                description     => "forward chain",
                chain           => "FORWARD",
                rule            => '
                                    def $ADDRESS_FASCH=194.177.211.201;
                                    def $ADDRESS_FIELD=194.177.211.210;
                                    def $FREEBSD_HOSTS=($ADDRESS_FASCH $ADDRESS_FIELD);

                                    policy ACCEPT;
                                    mod state state (ESTABLISHED RELATED) ACCEPT;
                                    interface vlan11 outerface eth0 jump from-kfreebsd;
                                    interface eth0 destination ($FREEBSD_HOSTS) jump to-kfreebsd;
                                    ULOG ulog-prefix "REJECT FORWARD: ";
                                    REJECT reject-with icmp-admin-prohibited;
                                    '
            }
        }
        luchesi: {
            @ferm::rule { "dsa-routing":
                description     => "forward chain",
                chain           => "FORWARD",
                rule            => '
                                    def $ADDRESS_FANO=206.12.19.110;
                                    def $ADDRESS_FINZI=206.12.19.111;
                                    def $FREEBSD_HOSTS=($ADDRESS_FANO $ADDRESS_FINZI);

                                    policy ACCEPT;
                                    mod state state (ESTABLISHED RELATED) ACCEPT;
                                    interface br0 outerface br0 ACCEPT;

                                    interface br2 outerface br0 jump from-kfreebsd;
                                    interface br0 destination ($FREEBSD_HOSTS) jump to-kfreebsd;
                                    ULOG ulog-prefix "REJECT FORWARD: ";
                                    REJECT reject-with icmp-admin-prohibited;
                                    '
            }
        }
    }

    # redirect snapshot into varnish
    case $hostname {
        sibelius: {
            @ferm::rule { "dsa-snapshot-varnish":
                rule            => '&SERVICE(tcp, 11371)'
            }
            @ferm::rule { "dsa-snapshot-varnish":
                table           => 'nat'
                chain           => 'PREROUTING'
                rule            => 'proto tcp daddr 193.62.202.28 dport 80 REDIRECT to-ports 6081'
            }
        }
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
