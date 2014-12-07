class ssh {

	package { [ 'openssh-client', 'openssh-server']:
		ensure => installed
	}

	service { 'ssh':
		ensure  => running,
		require => Package['openssh-server']
	}

	@ferm::rule { 'dsa-ssh':
		description => 'Allow SSH from DSA',
		rule        => '&SERVICE_RANGE(tcp, ssh, $SSH_SOURCES)'
	}
	@ferm::rule { 'dsa-ssh-v6':
		description => 'Allow SSH from DSA',
		domain      => 'ip6',
		rule        => '&SERVICE_RANGE(tcp, ssh, $SSH_V6_SOURCES)'
	}

	file { '/etc/ssh/ssh_config':
		content => template('ssh/ssh_config.erb'),
		require => Package['openssh-client']
	}
	file { '/etc/ssh/sshd_config':
		content => template('ssh/sshd_config.erb'),
		require => Package['openssh-server'],
		notify  => Service['ssh']
	}
	file { '/etc/ssh/userkeys':
		ensure  => directory,
		mode    => '0755',
		require => Package['openssh-server']
	}
	file { '/etc/ssh/userkeys/root':
		content => template('ssh/authorized_keys.erb'),
	}

	if ($::lsbmajdistrelease >= 8) {
		if ! $has_etc_ssh_ssh_host_ed25519_key {
			exec { 'create-ed25519-host-key':
				command => 'ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -q -P "" -t ed25519',
				onlyif  => '! [ -e /etc/ssh/ssh_host_ed25519_key ]'
			}
		}
	}
}
