Package {
    require => File["/etc/apt/apt.conf.d/local-recommends"]
}

node default {
    include munin-node
    include samhain
    include debian-org
    include exim

    case $raidcontroller {
        "true":    { include debian-proliant }
        default: {}
    }
}

