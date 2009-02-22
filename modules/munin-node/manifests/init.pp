class munin-node {

    package { munin-node: ensure => latest }

    file { "/etc/munin/munin-node.conf":
        owner   => root,
        group   => root,
        mode    => 664,
        source  => "puppet:///munin-node/munin-node.conf",
        require => Package["munin-node"],
        notify  => Exec["munin-node restart"],
    }

    exec { "munin-node restart":
        path        => "/etc/init.d/",
        refreshonly => true,
    }
}

