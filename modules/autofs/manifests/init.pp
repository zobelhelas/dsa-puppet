class autofs {
	case $::hostname {
		pejacevic, piu-slave-bm-a, picconi, coccia, dillon, donizetti, ticharich, delfin, quantz, sor, lindsay, mekeel, pinel, tate, manziarly, respighi: {
			include autofs::bytemark
		}
		lw07,lw08: {
			include autofs::leaseweb
		}
	}
}
