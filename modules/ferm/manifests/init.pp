#

class ferm {
	package { "ferm" :
		ensure		=> installed,
	}

	file { "/etc/ferm/dsa.d" :
		ensure		=> directory,
		owner		=> root,
		group		=> root,
		mode		=> 0700,
		require 	=> Package["ferm"],
	}

	file { "/etc/ferm/conf.d" :
		ensure		=>directory,
		owner		=> root,
		group		=> root,
		mode		=> 0700,
		require		=> Package["ferm"],
	}

	file { "/etc/ferm/ferm.conf" :
		ensure		=> present,
		owner		=> root,
		group		=> root,
		mode		=> 0600,
		require		=> Package["ferm"],
		notify		=> Exec["ferm reload"],
		source		=> "puppet:///ferm/ferm.conf",
	}

	file { "/etc/ferm/defs.conf" :
		ensure		=> present,
		owner		=> root,
		group		=> root,
		mode		=> 0600,
		require		=> Package["ferm"],
		notify		=> Exec["ferm reload"],
		source		=> "puppet:///ferm/defs.conf",
	}

	exec { "ferm reload":
		path		=> "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
		refreshonly	=> true,
	}

	# used as, e.g.:
	# ferm::rule { "dsa-ssh":
	# 	description	=> "Allow SSH from DSA",
	# 	rule		=> "proto tcp dport ssh saddr 1.2.3.4 ACCEPT"
	# }
	define rule($domain="ip", $chain="INPUT", $rule, $description="", $prio="00") {
		file { "/etc/ferm/dsa.d/${prio}_${name}":
			ensure	=> present,
			owner	=> root,
			group	=> root,
			mode	=> 0600,
			content => template("ferm/ferm-rule.erb"),
		}
	}
}
