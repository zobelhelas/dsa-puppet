define onion::service (
	$port,
	$target_address,
	$target_port
) {
	include onion

	concat::fragment { "onion::torrc_onionservice::${name}":
		target  => "/etc/tor/torrc",
		order   => 50,
		content => "HiddenServiceDir /var/lib/tor/onion/${name}\nHiddenServicePort ${port} ${target_address}:${target_port}\n\n",
	}

	$onion_hn = onion_hostname($name)
	if $onion_hn {
		$hostname_without_onion = regsubst($onion_hn, '\.onion$', '')
		@@concat::fragment { "onion::balance::instance::$name::$fqdn":
			target  => "/etc/onionbalance/config.yaml",
			content => "      - address: ${hostname_without_onion}\n        name: ${hostname}-${name}\n",
			order   => "50-${name}-20",
			tag     => "onion::balance::$name",
		}
	}
}
