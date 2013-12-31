# = Class: clamav
#
# Manage a clamav installation
#
# == Sample Usage:
#
#   include clamav
#
class clamav {
	package { [
			'clamav-daemon',
			'clamav-freshclam',
			'clamav-unofficial-sigs'
		]:
			ensure => installed
	}

	$extra_groups = $::mta ? {
		'postfix' => 'amavis',
		default   => 'Debian-exim'
	}

	user { 'clamav':
		gid     => clamav,
		groups  => [$extra_groups],
		require => Package['clamav-daemon']
	}

	service { 'clamav-daemon':
		ensure  => running,
		require => Package['clamav-daemon']
	}

	service { 'clamav-freshclam':
		ensure  => running,
		require => Package['clamav-freshclam']
	}

	file { [
		'/var/lib/clamav/mbl.ndb',
		'/var/lib/clamav/MSRBL-Images.hdb',
		'/var/lib/clamav/MSRBL-SPAM.ndb',
		'/var/lib/clamav/msrbl-images.hdb',
		'/var/lib/clamav/msrbl-spam.ndb',
	]:
		ensure => absent,
		notify => Service['clamav-daemon']
	}
	file { '/var/lib/clamav/.nobackup':
		owner   => clamav,
		mode    => '0644',
		content => '',
		require => Package['clamav-daemon']
	}
	file { '/etc/clamav-unofficial-sigs.dsa.conf':
		require => Package['clamav-unofficial-sigs'],
		source  => [ 'puppet:///modules/clamav/clamav-unofficial-sigs.dsa.conf' ]
	}
	file { '/etc/clamav-unofficial-sigs.conf':
		require => Package['clamav-unofficial-sigs'],
		source  => [ 'puppet:///modules/clamav/clamav-unofficial-sigs.conf' ]
	}

}
