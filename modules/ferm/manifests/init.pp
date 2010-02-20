class ferm {
	define ferm_rule($domain="ip", $chain="INPUT", $rule, $description="", $prio="00") {
	        file { "/etc/ferm/dsa.d/${prio}_${name}":
	                ensure  => present,
	                owner   => root,
	                group   => root,
	                mode    => 0600,
	                content => template("ferm/ferm-rule.erb"),
	        }
	}

        package { ferm: ensure => installed }

        file { 
                "/etc/ferm/dsa.d": 
                        ensure => directory,
                        require => Package["ferm"];
                "/etc/ferm/dsa.d/me.conf":
                        content => template("ferm/me.conf.erb"),
                        require => Package["ferm"],
                        notify  => Exec["ferm restart"];
        }

        exec { "ferm restart":
                path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
                refreshonly => true,
        }
}
