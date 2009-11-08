class resolv {
	file {	"/etc/resolv.conf":
			content => template("resolv/resolv.conf.erb");
	}
}
