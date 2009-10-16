define activate_munin_check($script) {
       file { "/etc/munin/plugins/$script":
                ensure => "/usr/share/munin/plugins/$script"
                notify => Exec["munin-node restart"];
        }
}

class munin-node {

    package { munin-node: ensure => installed }

    file { "/etc/munin/munin-node.conf":
        source  => [ "puppet:///munin-node/per-host/$fqdn/munin-node.conf",
                     "puppet:///munin-node/common/munin-node.conf" ],
        require => Package["munin-node"],
        notify  => Exec["munin-node restart"],
    }

    exec { "munin-node restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
}

