class autofs {
	case $::hostname {
		pejacevic, piu-slave-bm-a, picconi, coccia, couper, dillon, donizetti, ticharich, delfin, quantz, sor, lindsay, mekeel, pittar, pinel: {
			include autofs::bytemark
		}
		lw07,lw08: {
			include autofs::leaseweb
		}
	}
}
