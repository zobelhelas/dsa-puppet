class rng-tools {
	if inline_template("<% if File.exist?('/dev/hwrng') -%>true<% end -%>") {
		package { 'rng-tools':
			ensure => installed
		}
		service { 'rng-tools':
			ensure  => running,
			require => Package['rng-tools']
		}
	}
}
