class hardware {
	if $::smartarraycontroller {
		include debian::proliant
	}

	if $::productname == 'PowerEdge 2850' {
		include megactl
	}

	if $::mptraid {
		include raidmpt
	}

}
