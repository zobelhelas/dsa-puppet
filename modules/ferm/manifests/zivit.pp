class ferm::zivit {
	@ferm::rule { 'dsa-zivit-rrdcollect':
		description => 'port 6666 for rrdcollect for zivit',
		rule        => '&SERVICE_RANGE(tcp, 6666, ( 10.130.18.71 ))'
	}
	@ferm::rule { 'dsa-zivit-zabbix':
		description => 'port 10050 for zabbix for zivit',
		rule        => '&SERVICE_RANGE(tcp, 10050, ( 10.130.18.76 ))'
	}
	@ferm::rule { 'dsa-time':
		description => 'Allow time access',
		rule        => '&SERVICE_RANGE(tcp, time, \$HOST_NAGIOS_V4)'
	}
}

