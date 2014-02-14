class site {

	$localinfo = yamlinfo('*', '/etc/puppet/modules/debian-org/misc/local.yaml')
	$nodeinfo  = nodeinfo($::fqdn, '/etc/puppet/modules/debian-org/misc/local.yaml')
	$allnodeinfo = allnodeinfo('sshRSAHostKey ipHostNumber', 'purpose mXRecord physicalHost purpose')
        $roles = hiera('roles')

	service { 'procps':
		hasstatus   => false,
		status      => '/bin/true',
	}

}
