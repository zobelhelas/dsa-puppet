class hardware::sensors {
	if $::hw_can_temp_sensors {
		package { 'lm-sensors': ensure => installed, }
		munin::check { 'sensors_temp': script => 'sensors_' }
	}
	exec { 'invoke-rc.d munin-async restart':
		path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		refreshonly => true
	}
}
