class time {
	include stdlib
	$localtimeservers = hiera('local-timeservers', [])
	$physicalHost = $site::allnodeinfo[$fqdn]['physicalHost']

	# if ($::kernel == 'Linux' and $::is_virtual and $::virtual == 'kvm'
	# our is_virtual and virtual facts are broken
	if ($systemd and $physicalHost and size($localtimeservers) > 0) {
		include ntp::purge
		include systemdtimesyncd
	} else {
		include ntp
		include ntpdate
	}
}
