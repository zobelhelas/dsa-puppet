class munin-node::apache inherits munin-node {
        activate_munin_check { "apache_accesses", }
        activate_munin_check { "apache_processes", }
        activate_munin_check { "apache_volume", }
}

