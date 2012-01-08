class postgres {
    activate_munin_check {
        "postgres_bgwriter":;
        "postgres_connections_db":;
        "postgres_cache_ALL": script => "postgres_cache_";
        "postgres_querylength_ALL": script => "postgres_querylength_";
        "postgres_size_ALL": script => "postgres_size_";
    }
    file {
        "/etc/munin/plugin-conf.d/local-postgres":
            source  => "puppet:///modules/postgres/plugin.conf",
            ;
    }
}

# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:

