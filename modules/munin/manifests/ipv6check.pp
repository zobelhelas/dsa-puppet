define munin::ipv6check($ensure = present) {

	include munin

	if ! ($ensure in [absent,present]) {
		fail("unexpected ensure: ${ensure}")
	}

	file { "/etc/munin/plugins/${name}":
		ensure  => $ensure,
		content => "#!/bin/bash\n# This file is under puppet control\n. /usr/share/munin/plugins/ip_\n",
		mode    => '0555',
		require => Package['munin-node'],
		notify  => Service['munin-node'],
	}
}
