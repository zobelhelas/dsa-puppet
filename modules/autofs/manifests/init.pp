class autofs {
	case $::hostname {
		pejacevic, piu-slave-bm-a, picconi, coccia, dillon, donizetti, ticharich, delfin, quantz, sor, lindsay, mekeel, pittar, pinel, tate: {
			include autofs::bytemark
		}
		lw07,lw08: {
			include autofs::leaseweb
		}
	}
}
