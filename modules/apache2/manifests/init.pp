class apache2 {
        include munin-node::apache

	package {
		"apache2": ensure => installed;
		"logrotate": ensure => installed;
	}

        case $php {
                "true": { package {
				"php5-suhosin": ensure => installed;
			}
                          file { "/etc/php5/conf.d/suhosin.ini":
					source  => [ "puppet:///apache2/per-host/$fqdn/etc/php5/conf.d/suhosin.ini",
					             "puppet:///apache2/common/etc/php5/conf.d/suhosin.ini" ],
					require => Package["apache2", "php5-suhosin"],
                                        notify  => Exec["force-reload-apache2"];
			}
		}
	}


        define activate_apache_site($ensure=present, $site=$name) {
                case $site {
                        "": { $base = $name }
                        default: { $base = $site }
                }

                case $ensure {
                        present: {
                                file { "/etc/apache2/sites-enabled/$name":
                                         ensure => "/etc/apache2/sites-available/$base",
                                         require => Package["apache2"],
                                         notify => Exec["reload-apache2"];
                                }
                        }
                        absent: {
                                file { "/etc/apache2/sites-enabled/$name":
                                         ensure => $ensure,
                                         notify => Exec["reload-apache2"];
                                }
                        }
	                default: { err ( "Unknown ensure value: '$ensure'" ) }
                }
        }

	define enable_module($ensure=present) {
	        case $ensure {
	                present: {
	                        exec { "/usr/sbin/a2enmod $name":
	                                unless => "/bin/sh -c '[ -L /etc/apache2/mods-enabled/${name}.load ]'",
	                                notify => Exec["force-reload-apache2"],
	                        }
	                }
	                absent: {
	                        exec { "/usr/sbin/a2dismod $name":
	                                onlyif => "/bin/sh -c '[ -L /etc/apache2/mods-enabled/${name}.load ]'",
	                                notify => Exec["force-reload-apache2"],
	                        }
	                }
	                default: { err ( "Unknown ensure value: '$ensure'" ) }
	         }
	}

        enable_module {
                "info":;
                "status":;
        }

        activate_apache_site {
                "00-default": site => "default-debian.org";
                "000-default": ensure => absent;
        }

	file {
		"/etc/apache2/conf.d/ressource-limits":
			content => template("apache2/ressource-limits.erb"),
			require => Package["apache2"],
                        notify  => Exec["reload-apache2"];
		"/etc/apache2/conf.d/security":
			source  => [ "puppet:///apache2/per-host/$fqdn/etc/apache2/conf.d/security",
			             "puppet:///apache2/common/etc/apache2/conf.d/security" ],
			require => Package["apache2"],
                        notify  => Exec["reload-apache2"];
		"/etc/apache2/conf.d/local-serverinfo":
			source  => [ "puppet:///apache2/per-host/$fqdn/etc/apache2/conf.d/local-serverinfo",
			             "puppet:///apache2/common/etc/apache2/conf.d/local-serverinfo" ],
			require => Package["apache2"],
                        notify  => Exec["reload-apache2"];
		"/etc/apache2/conf.d/server-status":
			source  => [ "puppet:///apache2/per-host/$fqdn/etc/apache2/conf.d/server-status",
			             "puppet:///apache2/common/etc/apache2/conf.d/server-status" ],
			require => Package["apache2"],
                        notify  => Exec["reload-apache2"];

		"/etc/apache2/sites-available/default-debian.org":
			content => template("apache2/default-debian.org.erb"),
			require => Package["apache2"],
                        notify  => Exec["reload-apache2"];

		"/etc/logrotate.d/apache2":
			source  => [ "puppet:///apache2/per-host/$fqdn/etc/logrotate.d/apache2",
			             "puppet:///apache2/common/etc/logrotate.d/apache2" ];

		"/srv/www":
			mode    => 755,
			ensure  => directory;
		"/srv/www/default.debian.org":
			mode    => 755,
			ensure  => directory;
		"/srv/www/default.debian.org/htdocs":
			mode    => 755,
			ensure  => directory;
		"/srv/www/default.debian.org/htdocs/index.html":
			content => template("apache2/default-index.html");

		# sometimes this is a symlink
		#"/var/log/apache2":
		#	mode    => 755,
		#	ensure  => directory;
	}

	exec { "reload-apache2":
               command => "/etc/init.d/apache2 reload",
               refreshonly => true,
        }

        exec { "force-reload-apache2":
               command => "/etc/init.d/apache2 force-reload",
               refreshonly => true,
	}
}
