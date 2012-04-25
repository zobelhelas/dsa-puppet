class roles::backports_master {

	include roles::backports_mirror

	vsftpd::site { 'backports':
		source => 'puppet:///modules/roles/backports_master/vsftpd.conf'
	}
}
