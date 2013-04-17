class roles::weblog_destination {
	file { '/etc/ssh/userkeys/weblogsync':
		content => template('roles/weblog_destination-authorized_keys.erb'),
	}
}
