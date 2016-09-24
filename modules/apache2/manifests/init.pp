# = Class: apache2
#
# Standard apache config debian.org hosts
#
# == Sample Usage:
#
#   include apache2
#
class apache2 {
	package { 'apache2':
		ensure => installed,
	}

	service { 'apache2':
		ensure  => running,
		require => Package['apache2'],
	}

	apache2::module { 'info': }
	apache2::module { 'status': }
	apache2::module { 'headers': }

	package { 'libapache2-mod-macro':
		ensure => installed
	}

	apache2::module { 'macro':
		require => Package['libapache2-mod-macro']
	}

	apache2::site { '00-default':
		site     => 'default-debian.org',
		content  => template('apache2/default-debian.org.erb'),
	}
	apache2::site { 'xx-default-ssl':
		site     => 'default-debian.org-ssl',
		content  => template('apache2/default-debian.org-ssl.erb'),
	}

	apache2::site { '000-default':
		ensure => absent,
	}

	apache2::config { 'serve-cgi-bin':
		ensure => absent,
	}

	apache2::config { 'ressource-limits':
		ensure => absent,
	}

	if has_role('udd') {
		$memlimit = 512 * 1024 * 1024
	} elsif has_role('dgit_git') {
		$memlimit = 512 * 1024 * 1024
	} elsif has_role('sso') {
		$memlimit = 512 * 1024 * 1024
	} elsif has_role('popcon') {
		$memlimit = 512 * 1024 * 1024
	} elsif has_role('qamaster') {
		$memlimit = 300 * 1024 * 1024
	} else {
		$memlimit = 192 * 1024 * 1024
	}

	apache2::config { 'resource-limits':
		content => template('apache2/resource-limits.erb'),
	}

	apache2::config { 'security':
		source => 'puppet:///modules/apache2/security',
	}

	apache2::config { 'logformat-privacy':
		source => 'puppet:///modules/apache2/logformat-privacy',
	}

	apache2::config { 'local-serverinfo':
		source => 'puppet:///modules/apache2/local-serverinfo',
	}

	apache2::config { 'server-status':
		source => 'puppet:///modules/apache2/server-status',
	}

	apache2::config { 'puppet-ssl-macros':
		source => 'puppet:///modules/apache2/puppet-ssl-macros',
	}

	apache2::config { 'puppet-ftp-macros':
		source => 'puppet:///modules/apache2/puppet-ftp-macros',
	}

	apache2::config { 'puppet-config':
		content => template('apache2/puppet-config.erb'),
	}

	apache2::config { 'pratchett':
		source => 'puppet:///modules/apache2/pratchett',
	}

	if $::lsbmajdistrelease > 7 {
		file { '/etc/apache2/mods-available/mpm_worker.conf':
			content => template('apache2/mpm_worker.erb'),
		}
	}

	file { '/etc/apache2/sites-available/common-ssl.inc':
		ensure => absent,
	}

	file { '/etc/logrotate.d/apache2':
		source => 'puppet:///modules/apache2/apache2.logrotate',
	}

	file { [ '/srv/www', '/srv/www/default.debian.org', '/srv/www/default.debian.org/htdocs', '/srv/www/default.debian.org/htdocs-disabled' ]:
		ensure  => directory,
		mode    => '0755',
	}

	file { '/srv/www/default.debian.org/htdocs/index.html':
		content => template('apache2/default-index.html'),
	}

	file { '/srv/www/default.debian.org/htdocs-disabled/index.html':
		content => template('apache2/disabled-index.html'),
	}

	file { '/var/log/apache2/.nobackup':
		mode    => '0644',
		content => '',
	}

	munin::check { 'apache_accesses': }
	munin::check { 'apache_processes': }
	munin::check { 'apache_volume': }
	munin::check { 'apache_servers': }
	munin::check { 'ps_apache2':
		script => 'ps_',
	}

	if $::hostname in [beach,buxtehude,picconi,pkgmirror-1and1,pkgmirror-csail] {
		include apache2::dynamic
	} else {
		@ferm::rule { 'dsa-http':
			prio        => '23',
			description => 'Allow web access',
			rule        => '&SERVICE(tcp, (http https))'
		}
	}

	@ferm::rule { 'dsa-http-v6':
		domain          => '(ip6)',
		prio            => '23',
		description     => 'Allow web access',
		rule            => '&SERVICE(tcp, (http https))'
	}

	exec { 'service apache2 reload':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		command     => 'service apache2 reload',
		refreshonly => true,
		require =>  Package['apache2'],
	}

	apache2::config { 'puppet-ssl-key-pins':
		content => template('apache2/ssl-key-pins.erb'),
		notify  => Exec['service apache2 reload'],
	}
}
