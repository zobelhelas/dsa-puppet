# = Class: roles
#
# Lookup role and include relevant classes for roles
#
# == Sample Usage:
#
#   include roles
#
class roles {

	if has_role('puppetmaster') {
		include puppetmaster
	}

	if has_role('muninmaster') {
		include munin::master
	}

	if has_role('nagiosmaster') {
	#	include nagios::server
		ssl::service { 'nagios.debian.org':
			notify => Service['apache2'],
		}
	}

	# XXX: turn this into a real role
	if getfromhash($site::nodeinfo, 'buildd') {
		include buildd
	}

	# XXX: turn this into a real role
	if getfromhash($site::nodeinfo, 'porterbox') {
		include porterbox
	}

	if has_role('bugs_mirror') {
		include roles::bugs_mirror
	}

	if has_role('bugs_base') {
		ssl::service { 'bugs.debian.org':
			notify => Service['apache2'],
		}
	}
	if has_role('bugs_master') {
		ssl::service { 'bugs-master.debian.org':
			notify => Service['apache2'],
		}
	}

	if has_role('ftp_master') {
		include roles::ftp_master
		include roles::dakmaster
	}

	# XXX: turn this into a real role
	if getfromhash($site::nodeinfo, 'apache2_security_mirror') {
		include roles::security_mirror
	}

	# XXX: turn this into a real role
	if getfromhash($site::nodeinfo, 'apache2_www_mirror') {
		include roles::www_mirror
	}

	if has_role('ftp.d.o') {
		include roles::ftp
	}

	if has_role('ftp.upload.d.o') {
		include roles::ftp_upload
	}

	if has_role('git_master') {
		include roles::git_master
	}

	if has_role('security_master') {
		include roles::security_master
		include roles::dakmaster
	}

	if has_role('www_master') {
		include roles::www_master
	}

	if has_role('keyring') {
		include roles::keyring
	}

	if has_role('wiki') {
		include roles::wiki
	}

	if has_role('syncproxy') {
		include roles::syncproxy
	}

	if has_role('static_master') {
		include roles::static_master
	}

	if has_role('static_mirror') {
		include roles::static_mirror
	} elsif has_role('static_source') {
		include roles::static_source
	}

	if has_role('weblog_provider') {
		include roles::weblog_provider
	}

	if has_role('mailrelay') {
		include roles::mailrelay
	}

	if has_role('pubsub') {
		include roles::pubsub
	}

	if has_role('dbmaster') {
		include roles::dbmaster
	}

	if has_role('dns_primary') {
		include named::primary
	}

	if has_role('weblog_destination') {
		include roles::weblog_destination
	}

	if has_role('vote') {
		include roles::vote
	}

	if has_role('security_tracker') {
		include roles::security_tracker
	}

	if has_role('lists') {
		include roles::lists
	}

	if has_role('rtmaster') {
		include roles::rtmaster
	}

	if has_role('udd') {
		include roles::udd
	}

	if has_role('sso') {
		include roles::sso
	}

	if has_role('buildd_master') {
		include roles::buildd_master
	}

	if has_role('piuparts') {
		include roles::piuparts
	}

	if has_role('contributors') {
		include roles::contributors
	}

	if has_role('nm') {
		include roles::nm
	}

	if has_role('release') {
		include roles::release
	}

	if has_role('rtc') {
		include roles::rtc
	}

	if has_role('keystone') {
		include roles::keystone
	}

	if has_role('postgres_backup_server') {
		include postgres::backup_server
	}

	if has_role('packages') {
		ssl::service { 'packages.debian.org':
			notify => Service['apache2'],
		}
	}

	if has_role('gobby_debian_org') {
		ssl::service { 'gobby.debian.org':
			tlsaport => 0,
		}
	}
}
