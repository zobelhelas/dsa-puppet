class munin-node::apache inherits munin-node {
        activate_munin_check {
                "apache_accesses":  name => "apache_accesses";
                "apache_processes": name => "apache_processes";
                "apache_volume":    name => "apache_volume";
        }
}

