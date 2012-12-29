define ferm::module (
	$hookstage='pre',
	$mod=undef,
	$ensure=present
) {

	case $ensure {
		present,absent: {}
		default: { fail ( "Invalid ensure `${ensure}' for ${name}" ) }
	}

	if $mod {
		$module = $mod
	} else {
		$module = $title
	}

	$hook_prefix = $::lsbdistcodename ? {
		squeeze => '',
		default => '@',
	}

	if $::kernel == 'Linux' {
		file { "/etc/ferm/conf.d/load_${module}.conf":
			ensure  => $ensure,
			content => template('ferm/load_module.erb'),
			require => Package['ferm'],
			notify  => Service['ferm']
		}
	}
}
