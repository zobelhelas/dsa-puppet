class hardware::raid {
	if $::smartarraycontroller {
		include hardware::raid::proliant
	}

	if $::productname == 'PowerEdge 2850' {
		include hardware::raid::megactl
	}

	if $::mptraid {
		include hardware::raid::raidmpt
	}

}
