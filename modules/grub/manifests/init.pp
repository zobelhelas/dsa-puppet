class grub {
	if ($::kernel == 'Linux' and $::is_virtual and $::virtual == 'kvm') {
		file { '/etc/default/grub':
			source  => 'puppet:///modules/grub/etc-default-grub',
			notify  => Exec['update-grub']
		}

		exec { 'update-grub':
			refreshonly => true,
			path        => '/usr/bin:/usr/sbin:/bin:/sbin',
		}
	}
}
