class portforwarder {
	# do not depend on xinetd, yet.  it might uninstall other inetds
	# for now this will have to be done manually

	if $::portforwarder_user_exists {
		if ! $::portforwarder_key {
			exec { 'create-portforwarder-key':
				command => '/bin/su - portforwarder -c \'mkdir -p -m 02700 .ssh && ssh-keygen -C "`whoami`@`hostname` (`date +%Y-%m-%d`)" -P "" -f .ssh/id_rsa -q\'',
				onlyif  => '/usr/bin/getent passwd portforwarder > /dev/null && ! [ -e /home/portforwarder/.ssh/id_rsa ]'
			}
		}

		file { '/etc/ssh/userkeys/portforwarder':
			content => template('portforwarder/authorized_keys.erb'),
		}
		file { '/etc/xinetd.d':
			ensure  => directory,
			owner   => root,
			group   => root,
			mode    => '0755',
		}
		file { '/etc/xinetd.d/dsa-portforwader':
			content => template('portforwarder/xinetd.erb'),
			notify  => Exec['service xinetd reload']
		}

		exec { 'service xinetd reload':
			refreshonly => true,
		}
	} else {
		file { [
			'/etc/ssh/userkeys/portforwarder',
			'/etc/xinetd.d/dsa-portforwader',
			]:
			ensure => 'absent',
		}
	}
}
