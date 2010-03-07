class apache2 {
    activate_munin_check {
        "apache_accesses":;
        "apache_processes":;
        "apache_volume":;
        "apache_servers":;
        "ps_apache2": script => "ps_";
    }

    package {
        "apache2": ensure => installed;
        "logrotate": ensure => installed;
    }

    case $php5 {
        "true": {
            package {
                "php5-suhosin": ensure => installed;
            }

            file { "/etc/php5/conf.d/suhosin.ini":
                source  => [ "puppet:///apache2/per-host/$fqdn/etc/php5/conf.d/suhosin.ini",
                             "puppet:///apache2/common/etc/php5/conf.d/suhosin.ini" ],
                require => Package["apache2", "php5-suhosin"],
                notify  => Exec["force-reload-apache2"];
            }
        }
    }

    define activate_apache_site($ensure=present, $site=$name) {
        case $site {
            "": { $base = $name }
            default: { $base = $site }
        }

        case $ensure {
            present: {
                    file { "/etc/apache2/sites-enabled/$name":
                             ensure => "/etc/apache2/sites-available/$base",
                             require => Package["apache2"],
                             notify => Exec["reload-apache2"];
                    }
            }
            absent: {
                    file { "/etc/apache2/sites-enabled/$name":
                             ensure => $ensure,
                             notify => Exec["reload-apache2"];
                    }
            }
            default: { err ( "Unknown ensure value: '$ensure'" ) }
        }
    }

    define enable_module($ensure=present) {
        case $ensure {
            present: {
                exec { 
                      "/usr/sbin/a2enmod $name":
                        unless => "/bin/sh -c '[ -L /etc/apache2/mods-enabled/${name}.load ]'",
                        notify => Exec["force-reload-apache2"],
                }
            }
            absent: {
                exec {
                      "/usr/sbin/a2dismod $name":
                        onlyif => "/bin/sh -c '[ -L /etc/apache2/mods-enabled/${name}.load ]'",
                        notify => Exec["force-reload-apache2"],
                }
            }
            default: { err ( "Unknown ensure value: '$ensure'" ) }
        }
    }

    enable_module {
        "info":;
        "status":;
    }

    activate_apache_site {
        "00-default": site => "default-debian.org";
        "000-default": ensure => absent;
    }

    file {
        "/etc/apache2/conf.d/ressource-limits":
            content => template("apache2/ressource-limits.erb"),
            require => Package["apache2"],
                        notify  => Exec["reload-apache2"];
        "/etc/apache2/conf.d/security":
            source  => [ "puppet:///apache2/per-host/$fqdn/etc/apache2/conf.d/security",
                         "puppet:///apache2/common/etc/apache2/conf.d/security" ],
            require => Package["apache2"],
            notify  => Exec["reload-apache2"];
        "/etc/apache2/conf.d/local-serverinfo":
            source  => [ "puppet:///apache2/per-host/$fqdn/etc/apache2/conf.d/local-serverinfo",
                         "puppet:///apache2/common/etc/apache2/conf.d/local-serverinfo" ],
            require => Package["apache2"],
            notify  => Exec["reload-apache2"];
        "/etc/apache2/conf.d/server-status":
            source  => [ "puppet:///apache2/per-host/$fqdn/etc/apache2/conf.d/server-status",
                         "puppet:///apache2/common/etc/apache2/conf.d/server-status" ],
            require => Package["apache2"],
            notify  => Exec["reload-apache2"];

        "/etc/apache2/sites-available/default-debian.org":
            content => template("apache2/default-debian.org.erb"),
            require => Package["apache2"],
            notify  => Exec["reload-apache2"];

        "/etc/logrotate.d/apache2":
            source  => [ "puppet:///apache2/per-host/$fqdn/etc/logrotate.d/apache2",
                         "puppet:///apache2/common/etc/logrotate.d/apache2" ];

        "/srv/www":
            mode    => 755,
            ensure  => directory;
        "/srv/www/default.debian.org":
            mode    => 755,
            ensure  => directory;
        "/srv/www/default.debian.org/htdocs":
            mode    => 755,
            ensure  => directory;
        "/srv/www/default.debian.org/htdocs/index.html":
            content => template("apache2/default-index.html");

        # sometimes this is a symlink
        #"/var/log/apache2":
        #    mode    => 755,
        #    ensure  => directory;
    }

    exec {
        "reload-apache2":
            command => "/etc/init.d/apache2 reload",
            refreshonly => true;
        "force-reload-apache2":
            command => "/etc/init.d/apache2 force-reload",
            refreshonly => true;
    }

    @ferm::rule { "dsa-http-limit":
        prio            => "20",
        description     => "limit HTTP DOS",
        rule            => "chain 'http_limit' { mod limit limit-burst 60 limit 15/minute jump ACCEPT; jump DROP; }"
    }
    @ferm::rule { "dsa-http-soso":
        prio            => "21",
        description     => "slow yahoo spider",
        rule            => "chain 'limit_sosospider' { mod connlimit connlimit-above 2 connlimit-mask 21 jump DROP; jump http_limit; }"
    }
    @ferm::rule { "dsa-http-yahoo":
        prio            => "21",
        description     => "slow yahoo spider",
        rule            => "chain 'limit_yahoo' { mod connlimit connlimit-above 2 connlimit-mask 16 jump DROP; jump http_limit; }"
    }
    @ferm::rule { "dsa-http-rules":
        prio            => "22",
        description     => "http subchain",
        rule            => "chain 'http' { saddr ( 74.6.22.182 74.6.18.240 ) jump limit_yahoo; saddr 124.115.0.0/21 jump limit_sosospider; mod recent name HTTPDOS update seconds 1800 jump log_or_drop; mod hashlimit hashlimit-name HTTPDOS hashlimit-mode srcip hashlimit-burst 600 hashlimit 30/minute jump ACCEPT; mod recent name HTTPDOS set jump log_or_drop; }"
    }
    @ferm::rule { "dsa-http":
        prio            => "23",
        description     => "Allow web access",
        rule            => "proto tcp dport (http https) jump http;"
    }
    @ferm::rule { "dsa-http-v6":
        domain          => "(ip6)",
        prio            => "23",
        description     => "Allow web access",
        rule            => "&SERVICE(tcp, (http https))"
    }
}
# vim:set et:
# vim:set sts=4 ts=4:
# vim:set shiftwidth=4:
