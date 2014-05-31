class autofs::bytemark {
	include autofs::common

	file { '/etc/auto.master.d/dsa.autofs':
		source  => "puppet:///modules/autofs/leaseweb/auto.master.d-dsa.autofs",
		notify  => Exec['autofs reload']
	}
	file { '/etc/auto.dsa':
		source  => "puppet:///modules/autofs/leaseweb/auto.dsa",
		notify  => Exec['autofs reload']
	}
}
