class linux {
	include ferm
	include ferm::per-host
	include entropykey
	include rng-tools
}
