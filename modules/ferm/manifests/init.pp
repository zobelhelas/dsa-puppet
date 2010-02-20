class ferm {
	define rule($domain="ip", $chain="INPUT", $rule, $description="", $prio="00") {
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
                "/etc/ferm/conf.d": 
                        ensure => directory,
                        require => Package["ferm"];
                "/etc/ferm/ferm.conf":
                        source  => "puppet:///ferm/ferm.conf",
                        require => Package["ferm"],
                        notify  => Exec["ferm restart"];
                "/etc/ferm/conf.d/me.conf":
                        content => template("ferm/me.conf.erb"),
                        require => Package["ferm"],
                        notify  => Exec["ferm restart"];
        }

        ferm::rule { "dsa-ssh":
                description     => "Allow SSH from DSA",
                rule            => "proto tcp mod state state (NEW) dport (ssh) @subchain 'ssh' { saddr (\$SSH_SOURCES) ACCEPT; }"
        }

        exec { "ferm restart":
                path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
                refreshonly => true,
        }
}
