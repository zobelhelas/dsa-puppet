class ferm {
	define rule($domain="ip", $chain="INPUT", $rule, $description="", $prio="00") {
	        file { "/etc/ferm/dsa.d/${prio}_${name}":
	                ensure  => present,
	                owner   => root,
	                group   => root,
	                mode    => 0400,
	                content => template("ferm/ferm-rule.erb"),
                        notify  => Exec["ferm restart"],
	        }
	}

        # realize (i.e. enable) all @ferm::rule virtual resources
        Ferm::Rule <| |>

        package {
                ferm: ensure => installed;
                ulogd: ensure => installed;
        }

        file { 
                "/etc/ferm/dsa.d":
                        ensure => directory,
                        purge   => true,
                        force   => true,
                        recurse => true,
                        source  => "puppet:///files/empty/",
                        require => Package["ferm"];
                "/etc/ferm/conf.d":
                        ensure => directory,
                        require => Package["ferm"];
                "/etc/default/ferm":
                        source  => "puppet:///ferm/ferm.default",
                        require => Package["ferm"],
                        notify  => Exec["ferm restart"];
                "/etc/ferm/ferm.conf":
                        source  => "puppet:///ferm/ferm.conf",
                        require => Package["ferm"],
                        mode    => 0400,
                        notify  => Exec["ferm restart"];
                "/etc/ferm/conf.d/me.conf":
                        content => template("ferm/me.conf.erb"),
                        require => Package["ferm"],
                        mode    => 0400,
                        notify  => Exec["ferm restart"];
                "/etc/ferm/conf.d/defs.conf":
                        content => template("ferm/defs.conf.erb"),
                        require => Package["ferm"],
                        mode    => 0400,
                        notify  => Exec["ferm restart"];
                "/etc/ferm/conf.d/interfaces.conf":
                        content => template("ferm/interfaces.conf.erb"),
                        require => Package["ferm"],
                        mode    => 0400,
                        notify  => Exec["ferm restart"];
        }

        $munin_ips = split(regsubst($v4ips, '([^,]+)', 'ip_\1', 'G'), ',')

        activate_munin_check {
            $munin_ips: script => "ip_";
        }

        exec { "ferm restart":
                command     => "/etc/init.d/ferm restart",
                refreshonly => true,
        }

}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
