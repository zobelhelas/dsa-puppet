class roles::onionbalance {
	onion::balance_service { 'ftp.debian.org': }
	onion::balance_service { 'dsa.debian.org': }
	onion::balance_service { 'www.debian.org': }
	onion::balance_service { 'rtc.debian.org': }
	onion::balance_service { 'd-i.debian.org': }

	# do
	onion::balance_service { 'appstream.debian.org': }
	onion::balance_service { 'backports.debian.org': }
	onion::balance_service { 'bits.debian.org': }
	onion::balance_service { 'blends.debian.org': }
	onion::balance_service { 'lintian.debian.org': }
	onion::balance_service { 'onion.debian.org': }
	onion::balance_service { 'release.debian.org': }
	onion::balance_service { 'security-team.debian.org': }
	onion::balance_service { 'www.ports.debian.org': }
	# dn
	onion::balance_service { 'news.debian.net': }
	onion::balance_service { 'debaday.debian.net': }
	onion::balance_service { 'timeline.debian.net': }
	onion::balance_service { 'wnpp-by-tags.debian.net': }
	# dc
	onion::balance_service { 'debconf0.debconf.org': }
	onion::balance_service { 'debconf1.debconf.org': }
	onion::balance_service { 'debconf2.debconf.org': }
	onion::balance_service { 'debconf3.debconf.org': }
	onion::balance_service { 'debconf4.debconf.org': }
	onion::balance_service { 'debconf5.debconf.org': }
	onion::balance_service { 'debconf6.debconf.org': }
	onion::balance_service { 'debconf7.debconf.org': }
	onion::balance_service { '10years.debconf.org': }
	onion::balance_service { 'es.debconf.org': }
	onion::balance_service { 'fr.debconf.org': }
	onion::balance_service { 'miniconf10.debconf.org': }

	# non-SSL
	onion::balance_service { 'debdeltas.debian.net': }
	onion::balance_service { 'incoming.debian.org': }
	onion::balance_service { 'incoming.ports.debian.org': }
	onion::balance_service { 'metadata.ftp-master.debian.org': }
	onion::balance_service { 'mozilla.debian.net': }
	onion::balance_service { 'planet.debian.org': }
}
