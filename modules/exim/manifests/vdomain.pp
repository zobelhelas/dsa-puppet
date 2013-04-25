define exim::vdomain (
	$alias_file,
	$user,
	$group,
	$maildir="/srv/${name}",
	$domain=$name,
) {
	include exim::vdomain::setup

	file { $maildir:
		ensure => directory,
		mode   => '0755',
		owner  => root,
		group  => root
	}

	file { "${maildir}/mail":
		ensure => directory,
		mode   => '0755',
		owner  => root,
		group  => root
	}

	file { "${maildir}/mail/aliases":
		source => $alias_file,
		mode   => '0644',
		owner  => root,
		group  => root
	}

	concat::fragment { "virtualdomain_${domain}":
		target  => '/etc/exim4/virtualdomains',
		content => "${domain}: user=${user} group=${group} directory=${maildir}/mail\n",
	}
}
