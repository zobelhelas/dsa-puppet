class autofs {
	case $::hostname {
		pejacevic, piu-slave-bm-a, picconi, coccia, couper, dillon, donizetti, ticharich, delfin, quantz, sor: {
			include autofs::bytemark
		}
		lw07,lw08: {
			include autofs::leaseweb
		}
	}
}
