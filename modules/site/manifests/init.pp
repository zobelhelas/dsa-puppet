class site {

	$localinfo = yamlinfo('*', '/etc/puppet/modules/debian-org/misc/local.yaml')
	$nodeinfo  = nodeinfo($::fqdn, '/etc/puppet/modules/debian-org/misc/local.yaml')
	$allnodeinfo = allnodeinfo('sshRSAHostKey ipHostNumber', 'purpose mXRecord physicalHost purpose')
	notice( sprintf('hoster for %s is %s', $::fqdn, getfromhash($nodeinfo, 'hoster', 'name') ) )
	notice( sprintf('facter hoster for %s is %s', $::fqdn, $::hoster) )

	service { 'procps':
		hasstatus   => false,
		status      => '/bin/true',
	}
}
