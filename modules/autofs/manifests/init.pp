class autofs {
	if $::hostname in [pejacevic, piu-slave-bm-a, picconi] {
		include autofs::bytemark
	}
}
