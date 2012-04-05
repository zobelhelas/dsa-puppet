class hardware {
	if $::smartarraycontroller {
		include debian-org::proliant
	}

	if $::productname == 'PowerEdge 2850' {
		include megactl
	}

	if $::mptraid {
		include raidmpt
	}

}
