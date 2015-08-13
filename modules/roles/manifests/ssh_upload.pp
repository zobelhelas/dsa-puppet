class roles::ssh_upload {
	file { '/etc/ssh/userkeys/buildd-uploader':
		content => template('roles/ssh_upload_buildd-uploader-authorized_keys.erb'),
	}

	file { '/home/buildd-uploader/rsync-ssh-wrap':
		source => 'puppet:///modules/roles/ssh_upload/rsync-ssh-wrap',
		mode   => '0555',
	}
}
