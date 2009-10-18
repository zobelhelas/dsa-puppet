class named {
        include munin-node::bind

        package {
                bind9: ensure => installed;
        }

        exec {
                "bind9 restart":
                        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
                        refreshonly => true,
                        ;
        }
        exec {
                "bind9 reload":
                        path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
                        refreshonly => true,
                        ;
        }
}

# vim: set fdm=marker ts=8 sw=8 et:
