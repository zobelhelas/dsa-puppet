define activate_munin_check($ensure=present, $script = none) {
    case $script {
        none: { $link = $name }
        default: { $link = $script }
    }

    case $ensure {
        present: {
            file { "/etc/munin/plugins/$name":
                     ensure => "/usr/share/munin/plugins/$link",
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
}

class munin-node {

    package { munin-node: ensure => installed }

    activate_munin_check {
        "cpu":;
        "df":;
        "df_abs":;
        "df_inode":;
        "entropy":;
        "forks":;
        "interrupts":;
        "iostat":;
        "irqstats":;
        "load":;
        "memory":;
        "ntp_offset":;
        "ntp_states":;
        "open_files":;
        "open_inodes":;
        "processes":;
        "swap":;
        "uptime":;
        "vmstat":;
    }

    case $spamd {
        "true": {
              activate_munin_check { "spamassassin":; }
        }
    }

    case $vsftpd {
        "true": {
              include munin-node::vsftpd
        }
    }

    file {
        "/etc/munin/munin-node.conf":
            source  => [ "puppet:///munin-node/per-host/$fqdn/munin-node.conf",
                         "puppet:///munin-node/common/munin-node.conf" ],
            require => Package["munin-node"],
            notify  => Exec["munin-node restart"];

        "/etc/munin/plugin-conf.d/munin-node":
            content => template("munin-node/munin-node.plugin.conf.erb"),
            require => Package["munin-node"],
            notify  => Exec["munin-node restart"];
    }

    exec { "munin-node restart":
        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
        refreshonly => true,
    }
    ferm::rule { "dsa-munin":
            description     => "Allow munin from munin master",
            rule            => "proto tcp mod state state (NEW) dport (munin) @subchain 'munin' { saddr (\$HOST_MUNIN) ACCEPT; }"
    }
}

