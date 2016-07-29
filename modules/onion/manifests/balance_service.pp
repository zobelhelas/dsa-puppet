define onion::balance_service (
) {
	include onion::balance

	$onion_hn = onion_balance_service_hostname($name)
	if ! $onion_hn {
		exec { "create-onionbalance-key-${name}":
			command => "/bin/true && umask 0027 && openssl genrsa -out /etc/onionbalance/private_keys/${name}.key 1024 && chgrp onionbalance /etc/onionbalance/private_keys/${name}.key",
			onlyif  => "/bin/true && ! [ -e /etc/onionbalance/private_keys/${name}.key ]",
			require => Package['onionbalance'],
		}
	}

	concat::fragment { "onion::balance::service_header::${name}":
		target  => "/etc/onionbalance/config.yaml",
		order   => "50-${name}-10",
		content => "  - # ${name} via ${onion_hn}\n    key: private_keys/${name}.key\n    instances:\n",
	}

	Concat::Fragment <<| tag == "onion::balance::${name}" |>>
}
