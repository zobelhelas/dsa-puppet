class roles::backports_master {

	include roles::backports_mirror

	class { 'vsftpd::site':
		source => 'puppet:///modules/roles/backports_master/vsftpd.conf'
	}
}
