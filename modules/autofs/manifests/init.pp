class autofs {
	case $::hostname {
		pejacevic, piu-slave-bm-a, picconi, coccia, couper, dillon, donizetti, ticharich, delfin, quantz: {
			include autofs::bytemark
		}
		lw05,lw06: {
			include autofs::leaseweb
		}
	}
}
