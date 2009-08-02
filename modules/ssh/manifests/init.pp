class ssh {
	package {
                openssh-client: ensure => installed;
                openssh-server: ensure => installed;
        }

	file { "/etc/ssh/ssh_config":
		source  => [ "puppet:///ssh/ssh_config" ],
		require => Package["openssh-client"]
                ;
	       "/etc/ssh/sshd_config":
		content => template("ssh/sshd_config.erb"),
		require => Package["openssh-server"],
                notify  => Exec["ssh restart"]
                ;
	}

        exec { "ssh restart":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true,
        }
}
