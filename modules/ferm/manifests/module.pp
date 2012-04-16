define ferm::module (
	$hookstage='pre',
	$mod=undef,
	$ensure=present
) {
	if $mod {
		$module = $mod
	} else {
		$module = $title
	}

	file { "/etc/ferm/conf.d/load_${module}.conf":
		ensure  => $ensure,
		content => template('ferm/load_module.erb'),
		require => Package['ferm'],
		notify  => Service['ferm']
	}
}
