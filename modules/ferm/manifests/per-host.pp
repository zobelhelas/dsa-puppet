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
		bm-bl9: {
			@ferm::rule { 'dsa-iscsi':
				description     => 'Allow iscsi access',
				rule            => '&SERVICE_RANGE(tcp, 3260, ( 5.153.231.240/27 172.29.123.0/24 ))'
			}
		}
		oyens: {
			@ferm::rule { 'dsa-amqp':
				description     => 'Allow rabbitmq access',
				rule            => '&SERVICE_RANGE(tcp, 5672, ( 5.153.231.240/27 172.29.123.0/24 ))'
			}
			@ferm::rule { 'dsa-keystone':
				description     => 'Allow keystone access',
				rule            => '&SERVICE_RANGE(tcp, 5000, ( 5.153.231.240/27 172.29.123.0/24 ))'
			}
			@ferm::rule { 'dsa-keystone-admin':
				description     => 'Allow keystone access',
				rule            => '&SERVICE_RANGE(tcp, 35357, ( 5.153.231.240/27 172.29.123.0/24 ))'
			}
			@ferm::rule { 'dsa-glance-api':
				description     => 'Allow glance access',
				rule            => '&SERVICE_RANGE(tcp, 9292, ( 5.153.231.240/27 172.29.123.0/24 ))'
			}
			@ferm::rule { 'dsa-glance-registry':
				description     => 'Allow glance access',
				rule            => '&SERVICE_RANGE(tcp, 9191, ( 5.153.231.240/27 172.29.123.0/24 ))'
			}
			@ferm::rule { 'dsa-neutron':
				description     => 'Allow glance access',
				rule            => '&SERVICE_RANGE(tcp, 9696, ( 5.153.231.240/27 172.29.123.0/24 ))'
			}
			@ferm::rule { 'dsa-nova-ec2':
				description     => 'Allow nova access',
				rule            => '&SERVICE_RANGE(tcp, 8773, ( 5.153.231.240/27 172.29.123.0/24 ))'
			}
			@ferm::rule { 'dsa-nova2':
				description     => 'Allow nova access',
				rule            => '&SERVICE_RANGE(tcp, 8774, ( 5.153.231.240/27 172.29.123.0/24 ))'
			}
			@ferm::rule { 'dsa-nova-metadata':
				description     => 'Allow nova access',
				rule            => '&SERVICE_RANGE(tcp, 8775, ( 5.153.231.240/27 172.29.123.0/24 ))'
			}
			@ferm::rule { 'dsa-cinder':
				description     => 'Allow nova access',
				rule            => '&SERVICE_RANGE(tcp, 8776, ( 5.153.231.240/27 172.29.123.0/24 ))'
			}
		}
	}
	case $::hostname {
		czerny,clementi: {
			@ferm::rule { 'dsa-upsmon':
				description     => 'Allow upsmon access',
				rule            => '&SERVICE_RANGE(tcp, 3493, ( 82.195.75.64/26 192.168.43.0/24 ))'
			}
		}
		bendel: {
			@ferm::rule { 'listmaster-ontp-in':
				description => 'ONTP has a broken mail setup',
				table       => 'filter',
				chain       => 'INPUT',
				rule        => 'source 188.165.23.89/32 proto tcp dport 25 jump DROP',
			}
			@ferm::rule { 'listmaster-ontp-out':
				description => 'ONTP has a broken mail setup',
				table       => 'filter',
				chain       => 'OUTPUT',
				rule        => 'destination 78.8.208.246/32 proto tcp dport 25 jump DROP',
			}
		}
		abel,rietz,jenkins: {
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
		lw05: {
			@ferm::rule { 'dsa-snapshot-varnish':
				rule            => '&SERVICE(tcp, 6081)',
			}
			@ferm::rule { 'dsa-nat-snapshot-varnish':
				table           => 'nat',
				chain           => 'PREROUTING',
				rule            => 'proto tcp daddr 185.17.185.181 dport 80 REDIRECT to-ports 6081',
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
			@ferm::rule { 'dsa-bind-notrack-in':
				domain      => 'ip',
				description => 'NOTRACK for nameserver traffic',
				table       => 'raw',
				chain       => 'PREROUTING',
				rule        => 'proto (tcp udp) daddr 5.153.231.24 dport 53 jump NOTRACK'
			}

			@ferm::rule { 'dsa-bind-notrack-out':
				domain      => 'ip',
				description => 'NOTRACK for nameserver traffic',
				table       => 'raw',
				chain       => 'OUTPUT',
				rule        => 'proto (tcp udp) saddr 5.153.231.24 sport 53 jump NOTRACK'
			}

			@ferm::rule { 'dsa-bind-notrack-in6':
				domain      => 'ip6',
				description => 'NOTRACK for nameserver traffic',
				table       => 'raw',
				chain       => 'PREROUTING',
				rule        => 'proto (tcp udp) daddr 2001:41c8:1000:21::21:24 dport 53 jump NOTRACK'
			}

			@ferm::rule { 'dsa-bind-notrack-out6':
				domain      => 'ip6',
				description => 'NOTRACK for nameserver traffic',
				table       => 'raw',
				chain       => 'OUTPUT',
				rule        => 'proto (tcp udp) saddr 2001:41c8:1000:21::21:24 sport 53 jump NOTRACK'
			}
		}
		default: {}
	}

	# solr stuff
	case $::hostname {
		stockhausen: {
			@ferm::rule { 'dsa-solr-jetty':
				description     => 'Allow jetty access',
				rule            => '&SERVICE_RANGE(tcp, 8080, ( 82.195.75.100/32 ))'
			}
		}
	}

	# postgres stuff
	case $::hostname {
		ullmann: {
			@ferm::rule { 'dsa-postgres-udd':
				description     => 'Allow postgress access',
				# quantz, moszumanska, master, couper, coccia, franck
				rule            => '&SERVICE_RANGE(tcp, 5452, ( 5.153.231.28/32 5.153.231.21/32 82.195.75.110/32 5.153.231.14/32 5.153.231.11/32 138.16.160.12/32 ))'
			}
			@ferm::rule { 'dsa-postgres-udd6':
				domain          => '(ip6)',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5452, ( 2001:41c8:1000:21::21:28/128 2001:41b8:202:deb:216:36ff:fe40:4001/128 2001:41c8:1000:21::21:14/128 2001:41c8:1000:21::21:11/32 2001:41c8:1000:21::21:21/128 ))'
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

			@ferm::rule { 'dsa-postgres-backup':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 5.153.231.12/32 ))'
			}
			@ferm::rule { 'dsa-postgres-backup6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 2001:41c8:1000:21::21:12/128 ))'
			}
		}
		bmdb1: {
			@ferm::rule { 'dsa-postgres-main':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5435, ( 5.153.231.14/32 5.153.231.23/32 5.153.231.25/32 206.12.19.141/32 5.153.231.26/32 5.153.231.18/32 5.153.231.28/32 5.153.231.249/32 ))'
			}
			@ferm::rule { 'dsa-postgres-main6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5435, ( 2001:41c8:1000:21::21:14/128 2001:41c8:1000:21::21:23/128 2001:41c8:1000:21::21:25/128 2607:f8f0:610:4000:6564:a62:ce0c:138d/128 2001:41c8:1000:21::21:26/128 2001:41c8:1000:21::21:18/128 2001:41c8:1000:21::21:28/128 2001:41c8:1000:20::20:249/128))'
			}
			@ferm::rule { 'dsa-postgres-dak':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5434, ( 5.153.231.11/32 5.153.231.28/32 206.12.19.123/32 206.12.19.134/32 5.153.231.21/32 5.153.231.18/32 ))'
			}
			@ferm::rule { 'dsa-postgres-dak6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5434, ( 2001:41c8:1000:21::21:11/128 2001:41c8:1000:21::21:28/128 2607:f8f0:610:4000:216:36ff:fe40:3861/128 2607:f8f0:610:4000:6564:a62:ce0c:1386/128 2001:41c8:1000:21::21:21/128 2001:41c8:1000:21::21:18/128 ))'
			}
			@ferm::rule { 'dsa-postgres-wanna-build':
				# wuiet, ullmann, franck
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5436, ( 5.153.231.18/32 206.12.19.141/32 138.16.160.12/32 ))'
			}
			@ferm::rule { 'dsa-postgres-wanna-build6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5436, ( 2001:41c8:1000:21::21:18/128 2607:f8f0:610:4000:6564:a62:ce0c:138d/128 ))'
			}
			@ferm::rule { 'dsa-postgres-bacula':
				# dinis
				description     => 'Allow postgress access1',
				rule            => '&SERVICE_RANGE(tcp, 5437, ( 5.153.231.19/32 ))'
			}
			@ferm::rule { 'dsa-postgres-bacula6':
				domain          => 'ip6',
				description     => 'Allow postgress access1',
				rule            => '&SERVICE_RANGE(tcp, 5437, ( 2001:41c8:1000:21::21:19/128 ))'
			}

			@ferm::rule { 'dsa-postgres-backup':
				# ubc, wuit
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, (5435 5436), ( 5.153.231.12/32 ))'
			}
			@ferm::rule { 'dsa-postgres-backup6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, (5435 5436), ( 2001:41c8:1000:21::21:12/128 ))'
			}

			@ferm::rule { 'dsa-postgres-dedup':
				# ubc, wuit
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, (5439), ( 5.153.231.17/32 ))'
			}
			@ferm::rule { 'dsa-postgres-dedup6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, (5439), ( 2001:41c8:1000:21::21:17/128 ))'
			}
		}
		danzi: {
			@ferm::rule { 'dsa-postgres-danzi':
				# ubc, wuit
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 206.12.19.0/24 5.153.231.18/32 ))'
			}
			@ferm::rule { 'dsa-postgres-danzi6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 2607:f8f0:610:4000::/64 2001:41c8:1000:21::21:18/128 ))'
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

			@ferm::rule { 'dsa-postgres-backup':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 5.153.231.12/32 ))'
			}
			@ferm::rule { 'dsa-postgres-backup6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 2001:41c8:1000:21::21:12/128 ))'
			}
		}
		chopin: {
			@ferm::rule { 'dsa-postgres-backup':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5432, ( 5.153.231.12/32 ))'
			}
			@ferm::rule { 'dsa-postgres-backup6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5432, ( 2001:41c8:1000:21::21:12/128 ))'
			}
		}
		sibelius: {
			@ferm::rule { 'dsa-postgres-backup':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 5.153.231.12/32 ))'
			}
			@ferm::rule { 'dsa-postgres-backup6':
				domain          => 'ip6',
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 2001:41c8:1000:21::21:12/128 ))'
			}
			@ferm::rule { 'dsa-postgres-replication':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5433, ( 185.17.185.180/32 ))'
			}
		}
		lw04: {
			@ferm::rule { 'dsa-postgres-snapshot':
				description     => 'Allow postgress access',
				rule            => '&SERVICE_RANGE(tcp, 5439, ( 185.17.185.181/32 185.17.185.182/32 ))'
			}
		}
		default: {}
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
		default: {}
	}
}
