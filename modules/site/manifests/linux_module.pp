define site::linux_module ($ensure = present) {
	if $::kernel == linux {
		case $ensure {
			present: {
				exec { "append_module_${name}":
					command => "echo '${name}' >> /etc/modules",
					unless => "grep -q -F -x '${name}' /etc/modules",
				}
			}
			absent: {
				exec { "remove_module_${name}":
					command => "sed -i -e'/^${name}\$/d' /etc/modules",
					onlyif => "grep -q -F -x '${name}' /etc/modules",
				}
			}
			default: { fail ("invalid ensure value ${ensure}") }
		}
	}
}
