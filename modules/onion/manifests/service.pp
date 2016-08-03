define onion::service (
	$port,
	$target_address,
	$target_port,
	$ensure = present,
	$direct = false
) {
	if ($ensure == "ifstatic") {
		$my_ensure = has_static_component($name) ? {
			true => "present",
			false => "absent"
		}
	} else {
		$my_ensure = $ensure
	}

	if ($my_ensure == "present") {
		include onion

		concat::fragment { "onion::torrc_onionservice::${name}":
			target  => "/etc/tor/torrc",
			order   => 50,
			content => "HiddenServiceDir /var/lib/tor/onion/${name}\nHiddenServicePort ${port} ${target_address}:${target_port}\n\n",
		}

		$onion_hn = onion_tor_service_hostname($name)
		if $onion_hn {
			$hostname_without_onion = regsubst($onion_hn, '\.onion$', '')
			@@concat::fragment { "onion::balance::instance::$name::$fqdn":
				target  => "/etc/onionbalance/config.yaml",
				content => "      - address: ${hostname_without_onion}\n        name: ${hostname}-${name}\n",
				order   => "50-${name}-20",
				tag     => "onion::balance::$name",
			}

			if ($direct) {
				@@concat::fragment { "onion::balance::onionbalance-services.yaml::${name}":
					target  => "/srv/puppet.torproject.org/puppet-facts/onionbalance-services.yaml",
					content => "{\"${name}\": \"${onion_hn}\"}\n",
					tag     => "onionbalance-services.yaml",
				}
			} else {
				@@concat::fragment { "onion::balance::instance::dsa-snippet::$name::$fqdn":
					target  => "/etc/onionbalance/config-dsa-snippet.yaml",
					content => "- service: ${name}\n  address: ${hostname_without_onion}\n  host: ${hostname}-${name}\n",
					tag     => "onion::balance::dsa-snippet",
				}
			}
		}
	}
}
