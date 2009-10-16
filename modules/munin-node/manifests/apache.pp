class munin-node::apache {
        activate_munin_check("apache_accesses");
        activate_munin_check("apache_processes");
        activate_munin_check("apache_volume");
}

