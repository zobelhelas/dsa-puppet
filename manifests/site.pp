Package {
    require => File["/etc/apt/apt.conf.d/local-recommends"]
}

node default {
    include munin-node
    include samhain
    include debian-org

    case $smartarraycontroller {
        "true":    { include debian-proliant }
        default: {}

    case $mta {
        "exim4":   { include exim }
        default:   {}
    }
}

