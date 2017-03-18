class linux {
	include ferm
	include ferm::per_host
	include entropykey
	include rng_tools
}
