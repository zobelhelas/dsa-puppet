define ferm::rule (
	$rule,
	$domain='ip',
	$table='filter',
	$chain='INPUT',
	$description='',
	$prio='00',
	$notarule=false
) {

	include ferm

	file {
		"/etc/ferm/dsa.d/${prio}_${name}":
			ensure  => present,
			mode    => '0400',
			content => template('ferm/ferm_rule.erb'),
			notify  => Service['ferm'],
	}
}
