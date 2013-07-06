class autofs {
	if $::hostname in [pejacevic, piu-slave-bm-a, picconi, coccia] {
		include autofs::bytemark
	}
}
