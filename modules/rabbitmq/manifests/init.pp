# == Class: rabbitmq
#
# Top level class for all things rabbitmq
#
class rabbitmq (
	$cluster=false,
	$clustermembers=[],
	$clustercookie='',
	$delete_guest_user=false,
	$rabbit_num_ofiles=4096,
	$master=''
) {
	include rabbitmq::config

	package { 'rabbitmq-server':
		ensure  => installed,
	}

	service { 'rabbitmq-server':
		ensure  => running,
		enable  => true,
		require => Package['rabbitmq-server']
	}

	Service['rabbitmq-server'] -> Rabbitmq_user <| |>
	Service['rabbitmq-server'] -> Rabbitmq_vhost <| |>
	Service['rabbitmq-server'] -> Rabbitmq_user_permissions <| |>

	concat::fragment { 'rabbitmq_main_conf':
		target  => '/etc/rabbitmq/rabbitmq.config',
		order   => 00,
		content => template('rabbitmq/rabbitmq.conf.erb'),
	}

	concat::fragment { 'rabbit_foot':
		target  => '/etc/rabbitmq/rabbitmq.config',
		order   => 50,
		content => "]}\n"
	}

	concat::fragment { 'rabbitmq_conf_foot':
		target  => '/etc/rabbitmq/rabbitmq.config',
		order   => 99,
		content => "].\n"
	}

	file { '/etc/default/rabbitmq-server':
		content => template('rabbitmq/rabbitmq.ulimit.erb'),
		notify  => Service['rabbitmq-server']
	}

	if $cluster {
		if $clustercookie {
			file { '/var/lib/rabbitmq':
				ensure => directory,
				mode   => '0755',
				owner  => rabbitmq,
				group  => rabbitmq,
			}

			file { '/var/lib/rabbitmq/.erlang.cookie':
				content => $clustercookie,
				mode    => '0500',
				owner   => rabbitmq,
				group   => rabbitmq,
				before  => Package['rabbitmq-server'],
				notify  => Service['rabbitmq-server']
			}
		}

		if $::hostname != $master {
			exec { 'reset_mq':
				command => 'rabbitmqctl stop_app && rabbitmqctl reset > /var/lib/rabbitmq/.node_reset',
				path    => '/usr/bin:/bin:/usr/sbin:/sbin',
				creates => '/var/lib/rabbitmq/.node_reset',
				require => Package['rabbitmq-server'],
				notify  => Service['rabbitmq-server']
			}
			Exec['reset_mq'] -> Rabbitmq_user <| |>
			Exec['reset_mq'] -> Rabbitmq_vhost <| |>
			Exec['reset_mq'] -> Rabbitmq_user_permissions <| |>
		}
	}

	if $delete_guest_user {
		rabbitmq_user { 'guest':
			ensure   => absent,
			provider => 'rabbitmqctl',
		}
	}

	site::limit { 'rabbitmq_openfiles':
		limit_user  => rabbitmq,
		limit_value => $rabbit_num_ofiles,
		notify      => Service['rabbitmq-server']
	}
}
