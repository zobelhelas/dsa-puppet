class munin-node::apache inherits munin-node {
        activate_munin_check { 
                "apache_accesses";
                "apache_processes";
                "apache_volume";
        }
}

