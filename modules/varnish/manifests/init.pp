class varnish {

        package { 'varnish':
                ensure => installed,
        }

        service { 'varnish':
                ensure => running,
        }

        @ferm::rule { 'dsa-varnish':
                domain      => '(ip ip6)',
                description => 'Allow http access',
                rule        => '&TCP_SERVICE(80)'
        }

        file { '/etc/default/varnish':
		source => 'puppet:///modules/varnish/files/varnish.default',
                notify => Exec['varnish restart'],
        }

        file { '/etc/varnish/default.vcl':
		source => 'puppet:///modules/varnish/files/default.vcl',
                notify => Exec['varnish restart'],
        }
}

