class hardware {
	include hardware::raid

	case $::systemproductname {
		"ProLiant BL495c G5": {
			file { '/etc/apt/preferences.d/dsa-hp-tools':
				content => "Package: hp-health\nPin: version 8.6*\nPin-Priority: 1100\n"
			}
		}
	}
}
