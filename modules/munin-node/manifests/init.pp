class munin-node {

    package { munin-node: ensure => latest }

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

