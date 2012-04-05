class entropykey {

	if getfromhash($site::nodeinfo, 'entropy_key') {
		include entropykey::provider
	}

	$entropy_provider  = entropy_provider($::fqdn, $site::nodeinfo)
	case $entropy_provider {
		false:   {}
		local:   { include entropykey::local_consumer }
		default: {
			class { 'entropykey::remote_consumer':
				entropy_provider => $entropy_provider,
			}
		}
	}

}
