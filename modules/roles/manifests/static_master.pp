class roles::static_master {

	include roles::static_base

	file { '/usr/local/bin/static-master-run':
		source => 'puppet:///modules/roles/static-mirroring/static-master-run',
		mode   => '0555',
	}
	file { '/usr/local/bin/static-master-update-component':
		source => 'puppet:///modules/roles/static-mirroring/static-master-update-component',
		mode   => '0555',
	}
	file { '/etc/static-clients.conf':
		content => template('roles/static-mirroring/static-clients.conf.erb'),
	}

	# export some information for the onion.debian.org build
	if $::hostname in [dillon] {
		file { '/srv/puppet.debian.org':
			ensure => directory
		}
		file { '/srv/puppet.debian.org/puppet-facts':
			ensure => directory
		}
		concat { '/srv/puppet.debian.org/puppet-facts/onionbalance-services.yaml':
			notify  => Exec["rebuild-onion-website"],
		}
		Concat::Fragment <<| tag == "onionbalance-services.yaml" |>>

		exec { 'rebuild-onion-website':
			command => '/bin/su - staticsync -c \'make -C /srv/onion-master.debian.org\'',
			refreshonly => true,
		}
	}
}
