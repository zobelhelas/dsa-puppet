class resolv {
	file {	"/etc/resolv.conf":
			content => template("resolv/resolv.conf.erb");
	}
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
