class ferm {
	define rule($domain="ip", $chain="INPUT", $rule, $description="", $prio="00") {
	        file { "/etc/ferm/dsa.d/${prio}_${name}":
	                ensure  => present,
	                owner   => root,
	                group   => root,
	                mode    => 0600,
	                content => template("ferm/ferm-rule.erb"),
                        notify  => Exec["ferm restart"],
	        }
	}

        file { 
                "/etc/ferm": 
                        ensure => directory;
                "/etc/ferm/dsa.d": 
                        ensure => directory;
        }

        exec { "ferm restart":
                command     => "/bin/true",
                refreshonly => true,
        }

}
