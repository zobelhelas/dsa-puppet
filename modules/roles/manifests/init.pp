class roles {

	if getfromhash($site::nodeinfo, 'puppetmaster') {
		include puppetmaster
	}

	if getfromhash($site::nodeinfo, 'muninmaster') {
		include munin::master
	}

	if getfromhash($site::nodeinfo, 'nagiosmaster') {
		include nagios::server
	}

	if getfromhash($site::nodeinfo, 'buildd') {
		include buildd
	}

	if getfromhash($site::nodeinfo, 'bugs_mirror') {
		include roles::bugs_mirror
	}

	if getfromhash($site::nodeinfo, 'ftp_master') {
		include roles::ftp_master
		include roles::dakmaster
	}

	if getfromhash($site::nodeinfo, 'apache2_security_mirror') {
		include roles::security_mirror
	}

	if getfromhash($site::nodeinfo, 'apache2_www_mirror') {
		include roles::www_mirror
	}

	if getfromhash($site::nodeinfo, 'apache2_backports_mirror') {
		include roles::backports_mirror
	}

	if getfromhash($site::nodeinfo, 'ftp.d.o') {
		include roles::ftp
	}

	if getfromhash($site::nodeinfo, 'ftp.upload.d.o') {
		include roles::ftp_upload
	}

	if getfromhash($site::nodeinfo, 'backports_master') {
		include roles::backports_master
		include roles::dakmaster
	}

	if getfromhash($site::nodeinfo, 'security_master') {
		include roles::security_master
		include roles::dakmaster
	}

	if getfromhash($site::nodeinfo, 'www_master') {
		include roles::www_master
	}

	if getfromhash($site::nodeinfo, 'keyring') {
		include roles::keyring
	}

	if getfromhash($site::nodeinfo, 'apache2_ftp-upcoming_mirror') {
		include roles::ftp-upcoming_mirror
	}

	if getfromhash($site::nodeinfo, 'static_master') {
		include roles::static_master
	}

	if getfromhash($site::nodeinfo, 'static_mirror') {
		include roles::static_mirror
	} elsif getfromhash($site::nodeinfo, 'static_source') {
		include roles::static_source
	}
}
