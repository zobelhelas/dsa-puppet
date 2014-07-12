class autofs {
	case $::hostname {
		pejacevic, piu-slave-bm-a, picconi, coccia, couper, dillon, donizetti, ticharich, delfin, quantz: {
			include autofs::bytemark
		}
		lw05,lw06,lw07,lw08: {
			include autofs::leaseweb
		}
	}
}
