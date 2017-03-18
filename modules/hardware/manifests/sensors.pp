class hardware::sensors {
	if $::hw_can_temp_sensors {
		package { 'lm-sensors': ensure => installed, }
		munin::check { 'sensors_temp': script => 'sensors_' }
	} else {
		package { 'lm-sensors': ensure => purged, }
		munin::check { 'sensors_temp': ensure => absent }
	}
}
