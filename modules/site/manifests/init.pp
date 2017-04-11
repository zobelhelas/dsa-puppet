class site {

	$localinfo = yamlinfo('*')
	$nodeinfo  = nodeinfo($::fqdn)
	$allnodeinfo = allnodeinfo('sshRSAHostKey ipHostNumber', 'purpose mXRecord physicalHost purpose')
        $roles = hiera('roles')

	service { 'procps':
		hasstatus   => false,
		status      => '/bin/true',
	}

}
