class apache2 {
	file {
		"/etc/apache2/conf.d/security":
			source  => [ "puppet:///apache2/per-host/$fqdn/etc/apache2/conf.d/security",
			             "puppet:///apache2/common/etc/apache2/conf.d/security" ],
			require => Package["apache2"],
			notify  => Exec["apache2 reload"];

		"/etc/apache2/sites-available/default-debian.org":
			source  => [ "puppet:///apache2/per-host/$fqdn/etc/apache2/sites-available/default-debian.org",
			             "puppet:///apache2/common/etc/apache2/sites-available/default-debian.org" ],
			require => Package["apache2"],
			notify  => Exec["apache2 reload"];
		"/srv/www/default.debian.org/htdocs":
			mode    => 755,
			ensure  => directory;
		"/srv/www/default.debian.org/htdocs/index.html":
			content => template("default-index.html");
	}

	exec { "apache2 reload":
		path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
		refreshonly => true,
	}
}
