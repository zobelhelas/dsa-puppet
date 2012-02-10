class ferm {
    define rule($domain="ip", $table="filter", $chain="INPUT", $rule, $description="", $prio="00", $notarule=false) {
        file {
            "/etc/ferm/dsa.d/${prio}_${name}":
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
            notify  => Exec["ferm restart"],
            require => Package["ferm"];
        "/etc/ferm":
            ensure  => directory,
            mode    => 0755;
        "/etc/ferm/conf.d":
            ensure => directory,
            require => Package["ferm"];
        "/etc/default/ferm":
            source  => "puppet:///modules/ferm/ferm.default",
            require => Package["ferm"],
            notify  => Exec["ferm restart"];
        "/etc/ferm/ferm.conf":
            source  => "puppet:///modules/ferm/ferm.conf",
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
        "/etc/logrotate.d/ulogd":
            source => "puppet:///modules/ferm/logrotate-ulogd",
            require => Package["debian.org"],
            ;
    }

    $munin_ips = split(regsubst($v4ips, '([^,]+)', 'ip_\1', 'G'), ',')

    activate_munin_check {
        $munin_ips: script => "ip_";
    }

    define munin_ipv6_plugin() {
        file {
            "/etc/munin/plugins/$name":
                content =>  "#!/bin/bash\n# This file is under puppet control\n. /usr/share/munin/plugins/ip_\n",
                mode => 555,
                notify => Exec["munin-node restart"],
                ;
        }
    }
    case $v6ips {
        'no': {}
        default: {
           $munin6_ips = split(regsubst($v6ips, '([^,]+)', 'ip_\1', 'G'), ',')
            munin_ipv6_plugin {
                $munin6_ips: ;
            }
           # get rid of old stuff
           $munin6_ip6s = split(regsubst($v6ips, '([^,]+)', 'ip_\1', 'G'), ',')
           activate_munin_check {
               $munin6_ips: ensure => absent;
           }
        }
    }


    case getfromhash($nodeinfo, 'buildd') {
        true: {
            file {
                "/etc/ferm/conf.d/load_ftp_conntrack.conf":
                    source => "puppet:///modules/ferm/conntrack_ftp.conf",
                    require => Package["ferm"],
                    notify  => Exec["ferm restart"];
            }
        }
    }

    exec {
        "ferm restart":
            command     => "/etc/init.d/ferm restart",
            refreshonly => true,
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
