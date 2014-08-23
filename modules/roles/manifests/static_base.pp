class roles::static_base {
	if ! $::staticsync_key {
		exec { 'create-staticsync-key':
			command => '/bin/su - staticsync -c \'mkdir -p -m 02700 .ssh && ssh-keygen -C "`whoami`@`hostname` (`date +%Y-%m-%d`)" -P "" -f .ssh/id_rsa -q\'',
			onlyif  => '/usr/bin/getent passwd staticsync > /dev/null && ! [ -e /home/staticsync/.ssh/id_rsa ]'
		}
	}

	file { '/etc/static-components.conf':
		source => 'puppet:///modules/roles/static-mirroring/static-components.conf',
	}

	file { '/etc/ssh/userkeys/staticsync':
		content => template('roles/static-mirroring/staticsync-authorized_keys.erb'),
	}

	file { '/usr/local/bin/staticsync-ssh-wrap':
		source => 'puppet:///modules/roles/static-mirroring/staticsync-ssh-wrap',
		mode   => '0555',
	}
	file { '/usr/local/bin/static-mirror-ssh-wrap': ensure => absent; }
	file { '/usr/local/bin/static-master-ssh-wrap': ensure => absent; }

	@ferm::rule { 'dsa-static-bt-v4':
		description => 'Allow bt between static hosts',
		rule        => 'proto tcp mod state state (NEW) mod multiport destination-ports (6881:6999) @subchain \'static-bt\' { saddr ($HOST_STATIC_V4) ACCEPT; }',
		notarule    => true,
	}
	@ferm::rule { 'dsa-static-bt-v6':
		description => 'Allow bt between static hosts',
		domain      => 'ip6',
		rule        => 'proto tcp mod state state (NEW) mod multiport destination-ports (6881:6999) @subchain \'static-bt\' { saddr ($HOST_STATIC_V6) ACCEPT; }',
		notarule    => true,
	}
}
