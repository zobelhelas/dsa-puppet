class hardware::raid {
	include hardware::raid::proliant

	if $::productname == 'PowerEdge 2850' {
		include hardware::raid::megactl
	}

	include hardware::raid::raidmpt
}
