define ferm::module (
	$module,
	$hookstage='pre',
	$ensure=present
) {
	file { "/etc/ferm/conf.d/load_${module}.conf":
		ensure  => $ensure,
		content => template('ferm/load_module.erb'),
		require => Package['ferm'],
		notify  => Service['ferm']
	}
}
