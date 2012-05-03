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

	apache2::site { '00-default':
		site     => 'default-debian.org',
		template => 'apache2/default-debian.org.erb',
	}

	apache2::site { '000-default':
		ensure => absent,
	}

	apache2::config { 'ressource-limits':
		content => template('apache2/ressource-limits.erb'),
	}

	apache2::config { 'security':
		source => 'puppet:///modules/apache2/security',
	}

	apache2::config { 'local-serverinfo':
		source => 'puppet:///modules/apache2/local-serverinfo',
	}

	apache2::config { 'server-status':
		source => 'puppet:///modules/apache2/server-status',
	}

	file { '/etc/apache2/sites-available/common-ssl.inc':
		source => 'puppet:///modules/apache2/common-ssl.inc',
		require => Package['apache2'],
		notify  => Service['apache2'],
	}

	file { '/etc/logrotate.d/apache2':
		source => 'puppet:///modules/apache2/apache2.logrotate',
	}

	file { [ '/srv/www', '/srv/www/default.debian.org', '/srv/www/default.debian.org/htdocs' ]:
		ensure  => directory,
		mode    => '0755',
	}

	file { '/srv/www/default.debian.org/htdocs/index.html':
		content => template('apache2/default-index.html'),
	}

	munin::check { 'apache_accesses': }
	munin::check { 'apache_processes': }
	munin::check { 'apache_volume': }
	munin::check { 'apache_servers': }
	munin::check { 'ps_apache2':
		script => 'ps_',
	}

	if $php5 {
		package { 'php5-suhosin':
			ensure  => installed,
			require => Package['apache2'],
		}

		file { '/etc/php5/conf.d/suhosin.ini':
			source  => 'puppet:///modules/apache2/suhosin.ini',
			require => Package['php5-suhosin'],
			notify  => Service['apache2'],
		}
	}

	if $::hostname in [busoni,duarte,holter,lindberg,master,powell] {
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
}
