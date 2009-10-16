class munin-node::apache inherits munin-node {
        activate_munin_check { "Apache munin plugins:
                script => "apache_accesses";
                script => "apache_processes";
                script => "apache_volume";
        }
}

