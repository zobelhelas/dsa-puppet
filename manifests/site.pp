Package {
    require => File["/etc/apt/apt.conf.d/local-recommends"]
}

node default {
    include munin-node
    include samhain
    include debian-org

    if $smartarraycontroller {
        include debian-proliant
    }
    case $mta {
        "exim4":   { include exim }
        default:   {}
    }
}

