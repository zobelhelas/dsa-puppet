class varnish {

        package { 'varnish':
                ensure => installed,
        }

        service { 'varnish':
                ensure => running,
        }

	include apache2::dynamic

        @ferm::rule { 'dsa-varnish':
                domain      => '(ip ip6)',
		prio        => '100',
                description => 'Allow http access',
		rule        => '&SERVICE(tcp, 80)'
        }

        file { '/etc/default/varnish':
		source  => 'puppet:///modules/varnish/varnish.default',
		require =>  Package['varnish'],
                notify  =>  Service['varnish'],
		mode    => '0444',
        }

        file { '/etc/varnish/default.vcl':
		source => 'puppet:///modules/varnish/default.vcl',
		require =>  Package['varnish'],
		notify =>  Service['varnish'],
		mode    => '0444',
        }

        file { '/etc/logrotate.d/varnish':
		source => 'puppet:///modules/varnish/varnish.logrotate',
		require =>  Package['varnish'],
		mode    => '0444',
        }
}

