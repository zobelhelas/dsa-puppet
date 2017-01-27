class autofs {
	case $::hostname {
		pejacevic, piu-slave-bm-a, picconi, coccia, dillon, donizetti, ticharich, delfin, quantz, sor, lindsay, mekeel, pinel, tate, manziarly, respighi, bilbao: {
			include autofs::bytemark
		}
		lw07,lw08: {
			include autofs::leaseweb
		}
		tye,ullmann: {
			include autofs::ubc
		}
	}
}
