define munin::check($ensure = present, $script = undef) {

	include munin

	if $script {
		$link = $script
	} else {
		$link = $name
	}

	$link_target = $ensure ? {
		present => "/usr/share/munin/plugins/${link}",
		absent  => absent,
		default => fail ( "Unknown ensure value: '$ensure'" ),
	}

	file { "/etc/munin/plugins/${name}":
		ensure  => $link_target,
		require => Package['munin-node'],
		notify  => Service['munin-node'],
	}
}
