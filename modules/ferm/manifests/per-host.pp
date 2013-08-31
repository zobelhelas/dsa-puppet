class ferm::per-host {
	if $::hostname in [ancina,zandonai,zelenka] {
		include ferm::zivit
	}

	if $::hostname in [glinka,klecker,ravel,rietz,senfl,sibelius,stabile] {
		ferm::rule { 'dsa-rsync':
			domain      => '(ip ip6)',
			description => 'Allow rsync access',
			rule        => '&SERVICE(tcp, 873)'
		}
	}

	case $::hostname {
		samosa: {
			@ferm::rule { 'dsa-udd-stunnel':
				description  => 'port 8080 for udd stunnel',
				rule         => '&SERVICE_RANGE(tcp, http-alt, ( 192.25.206.16 70.103.162.29 217.196.43.134 ))'
			}
		}
		czerny,clementi: {
			@ferm::rule { 'dsa-upsmon':
				description     => 'Allow upsmon access',
				rule            => '&SERVICE_RANGE(tcp, 3493, ( 82.195.75.64/26 192.168.43.0/24 ))'
			}
		}
		bendel: {
			@ferm::rule { 'listmaster-ontp-in':
				description	=> 'ONTP has a broken mail setup',
				table		=> 'filter',
				chain		=> 'INPUT',
				rule		=> 'source 188.165.23.89/32 proto tcp dport 25 jump DROP',
			}
			@ferm::rule { 'listmaster-ontp-out':
				description	=> 'ONTP has a broken mail setup',
				table		=> 'filter',
				chain		=> 'OUTPUT',
				rule		=> 'destination 78.8.208.246/32 proto tcp dport 25 jump DROP',
			}
		}
		abel,alwyn,rietz: {
			@ferm::rule { 'dsa-tftp':
				description     => 'Allow tftp access',
				rule            => '&SERVICE(udp, 69)'
			}
		}
		paganini: {
			@ferm::rule { 'dsa-dhcp':
				description     => 'Allow dhcp access',
				rule            => '&SERVICE(udp, 67)'
			}
			@ferm::rule { 'dsa-tftp':
				description     => 'Allow tftp access',
				rule            => '&SERVICE(udp, 69)'
			}
		}
		lotti,lully: {
			@ferm::rule { 'dsa-syslog':
				description     => 'Allow syslog access',
				rule            => '&SERVICE_RANGE(tcp, 5140, $HOST_DEBIAN_V4)'
			}
			@ferm::rule { 'dsa-syslog-v6':
				domain          => 'ip6',
				description     => 'Allow syslog access',
				rule            => '&SERVICE_RANGE(tcp, 5140, $HOST_DEBIAN_V6)'
			}
		}
		kaufmann: {
			@ferm::rule { 'dsa-hkp':
				domain          => '(ip ip6)',
				description     => 'Allow hkp access',
				rule            => '&SERVICE(tcp, 11371)'
			}
		}
		gombert: {
			@ferm::rule { 'dsa-infinoted':
				domain          => '(ip ip6)',
				description     => 'Allow infinoted access',
				rule            => '&SERVICE(tcp, 6523)'
			}
		}
		draghi: {
			#@ferm::rule { 'dsa-bind':
			#    domain          => '(ip ip6)',
			#    description     => 'Allow nameserver access',
			#    rule            => '&TCP_UDP_SERVICE(53)'
			#}
			@ferm::rule { 'dsa-finger':
				domain          => '(ip ip6)',
				description     => 'Allow finger access',
				rule            => '&SERVICE(tcp, 79)'
			}
			@ferm::rule { 'dsa-ldap':
				domain          => '(ip ip6)',
				description     => 'Allow ldap access',
				rule            => '&SERVICE(tcp, 389)'
			}
			@ferm::rule { 'dsa-ldaps':
				domain          => '(ip ip6)',
				description     => 'Allow ldaps access',
				rule            => '&SERVICE(tcp, 636)'
			}
		}
		cilea: {
			ferm::module { 'nf_conntrack_sip': }
			ferm::module { 'nf_conntrack_h323': }

			@ferm::rule { 'dsa-sip':
				domain          => '(ip ip6)',
				description     => 'Allow sip access',
				rule            => '&TCP_UDP_SERVICE(5060)'
			}
			@ferm::rule { 'dsa-sipx':
				domain          => '(ip ip6)',
				description     => 'Allow sipx access',
				rule            => '&TCP_UDP_SERVICE(5080)'
			}
		}
		unger: {
			@ferm::rule { 'dsa-notrack-dns-diamond-in':
				domain      => 'ip',
				description => 'NOTRACK for nameserver traffic',
				table       => 'raw',
				chain       => 'PREROUTING',
				rule        => 'destination 82.195.75.108 proto (tcp udp) dport 53 jump NOTRACK'
			}
			@ferm::rule { 'dsa-notrack-dns-diamond-out':
				domain      => 'ip',
				description => 'NOTRACK for nameserver traffic',
				table       => 'raw',
				chain       => 'PREROUTING',
				rule        => 'source 82.195.75.108 proto (tcp udp) sport 53 jump NOTRACK'
			}
		}
		sonntag: {
			@ferm::rule { 'dsa-bugs-search':
				description  => 'port 1978 for bugs-search from bug web frontends',
				rule         => '&SERVICE_RANGE(tcp, 1978, ( 140.211.166.26 206.12.19.140 ))'
			}
		}
		default: {}
	}

	if $::hostname in [rautavaara] {
		@ferm::rule { 'dsa-from-mgmt':
			description     => 'Traffic routed from mgmt net vlan/bridge',
			chain           => 'INPUT',
			rule            => 'interface eth1 ACCEPT'
		}
		@ferm::rule { 'dsa-mgmt-mark':
			table           => 'mangle',
			chain           => 'PREROUTING',
			rule            => 'interface eth1 MARK set-mark 1',
		}
		@ferm::rule { 'dsa-mgmt-nat':
			table           => 'nat',
			chain           => 'POSTROUTING',
			rule            => 'outerface eth1 mod mark mark 1 MASQUERADE',
		}
	}

	# redirect snapshot into varnish
	case $::hostname {
		sibelius: {
			@ferm::rule { 'dsa-snapshot-varnish':
				rule            => '&SERVICE(tcp, 6081)',
			}
			@ferm::rule { 'dsa-nat-snapshot-varnish':
				table           => 'nat',
				chain           => 'PREROUTING',
				rule            => 'proto tcp daddr 193.62.202.30 dport 80 REDIRECT to-ports 6081',
			}
		}
		stabile: {
			@ferm::rule { 'dsa-snapshot-varnish':
				rule            => '&SERVICE(tcp, 6081)',
			}
			@ferm::rule { 'dsa-nat-snapshot-varnish':
				table           => 'nat',
				chain           => 'PREROUTING',
				rule            => 'proto tcp daddr 206.12.19.150 dport 80 REDIRECT to-ports 6081',
			}
		}
		default: {}
	}
	case $::hostname {
		bm-bl1,bm-bl2: {
			@ferm::rule { 'dsa-vrrp':
				rule            => 'proto vrrp daddr 224.0.0.18 jump ACCEPT',
			}
			@ferm::rule { 'dsa-conntrackd':
				rule            => 'interface vlan2 daddr 225.0.0.50 jump ACCEPT',
			}
		}
		default: {}
	}

	# postgres stuff
	case $::hostname {
		ullmann: {
			@ferm::rule { 'dsa-postgres-udd':
				description     => 'Allow postgress access',
				# quantz, wagner, master, couper
				rule            => '&SERVICE_RANGE(tcp, 5452, ( 206.12.19.122/32 217.196.43.134/32 217.196.43.132/32 82.195.75.110/32 5.153.231.14/32 ))'
			}
			@ferm::rule { 'dsa-postgres-udd6':
				domain          => '(ip6)',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5452, ( 2607:f8f0:610:4000:216:36ff:fe40:3860/128 2001:41b8:202:deb:216:36ff:fe40:4001/128 2001:41c8:1000:21::21:14/128 ))'
			}
		}
		grieg: {
			@ferm::rule { 'dsa-postgres-ullmann':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 206.12.19.141/32 ))'
			}
			@ferm::rule { 'dsa-postgres-ullmann6':
				domain          => '(ip6)',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 2607:f8f0:610:4000:6564:a62:ce0c:138d/128 ))'
			}
		}
		franck: {
			@ferm::rule { 'dsa-postgres-franck':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 5.153.231.10/32 ))'
			}
			@ferm::rule { 'dsa-postgres-franck6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 2001:41c8:1000:21::21:10/128 ))'
			}
		}
		bmdb1: {
			@ferm::rule { 'dsa-postgres-main':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5435, ( 5.153.231.14/32 ))'
			}
			@ferm::rule { 'dsa-postgres-main6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5435, ( 2001:41c8:1000:21::21:14/128 ))'
			}
			@ferm::rule { 'dsa-postgres-dak':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5434, ( 5.153.231.11/32 206.12.19.122/32 206.12.19.123/32 206.12.19.134/32 ))'
			}
			@ferm::rule { 'dsa-postgres-dak6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5434, ( 2001:41c8:1000:21::21:11/128 2607:f8f0:610:4000:216:36ff:fe40:3860/128 2607:f8f0:610:4000:216:36ff:fe40:3861/128 2607:f8f0:610:4000:6564:a62:ce0c:1386/128 ))'
			}
		}
		danzi: {
			@ferm::rule { 'dsa-postgres-danzi':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 206.12.19.0/24 194.177.211.200/32 ))'
			}
			@ferm::rule { 'dsa-postgres-danzi6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 2607:f8f0:610:4000::/64 2001:648:2ffc:deb:214:22ff:fe74:1fa/128 ))'
			}

			@ferm::rule { 'dsa-postgres2-danzi':
				description     => 'Allow postgress access2',
				rule            => '&SERVICE_RANGE(tcp, 5437, ( 206.12.19.0/24 ))'
			}
			@ferm::rule { 'dsa-postgres3-danzi':
				description     => 'Allow postgress access3',
				rule            => '&SERVICE_RANGE(tcp, 5436, ( 206.12.19.0/24 ))'
			}
			@ferm::rule { 'dsa-postgres4-danzi':
				description     => 'Allow postgress access4',
				rule            => '&SERVICE_RANGE(tcp, 5438, ( 206.12.19.0/24 ))'
			}

			@ferm::rule { 'dsa-postgres-bacula-danzi':
				description     => 'Allow postgress access1',
				rule            => '&SERVICE_RANGE(tcp, 5434, ( 206.12.19.139/32 ))'
			}
			@ferm::rule { 'dsa-postgres-bacula-danzi6':
				domain          => 'ip6',
				description     => 'Allow postgress access1',
				rule            => '&SERVICE_RANGE(tcp, 5434, ( 2607:f8f0:610:4000:6564:a62:ce0c:138b/128 ))'
			}
		}
	}
	# vpn fu
	case $::hostname {
		draghi,eysler: {
			@ferm::rule { 'dsa-vpn':
				description     => 'Allow openvpn access',
				rule            => '&SERVICE(udp, 17257)'
			}
			@ferm::rule { 'dsa-routing':
				description     => 'forward chain',
				chain           => 'FORWARD',
				rule            => 'policy ACCEPT;
mod state state (ESTABLISHED RELATED) ACCEPT;
interface tun+ ACCEPT;
REJECT reject-with icmp-admin-prohibited
'
			}
			@ferm::rule { 'dsa-vpn-mark':
				table           => 'mangle',
				chain           => 'PREROUTING',
				rule            => 'interface tun+ MARK set-mark 1',
			}
			@ferm::rule { 'dsa-vpn-nat':
				table           => 'nat',
				chain           => 'POSTROUTING',
				rule            => 'outerface !tun+ mod mark mark 1 MASQUERADE',
			}
		}
	}
}
