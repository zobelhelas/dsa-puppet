define activate_munin_check($ensure=present) {
    case $ensure {
        present: {
            file { "/etc/munin/plugins/$name":
                     ensure => "/usr/share/munin/plugins/$name",
                     notify => Exec["munin-node restart"];
            }
        }
        default: {
            file { "/etc/munin/plugins/$name":
                     ensure => $ensure,
                     notify => Exec["munin-node restart"];
            }
        }
}

class munin-node {

    package { munin-node: ensure => installed }

    activate_munin_check {
        "cpu":;
        "df":;
        "df_inode":;
        "entropy":;
        "forks":;
        "interrupts":;
        "iostat":;
        "irqstats":;
        "load":;
        "memory":;
        "ntp_offset":;
        "open_files":;
        "open_inodes":;
        "processes":;
        "swap":;
        "vmstat":;
    }

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

