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
              "/etc/ssh/userkeys":
		ensure  => directory,
		owner   => root,
		group   => root,
		mode    => 755,
                ;
              "/etc/ssh/userkeys/root":
                content => template("ssh/authorized_keys.erb"),
                mode    => 444,
                require => Package["openssh-server"]
                ;
	}

        exec { "ssh restart":
            path        => "/etc/init.d:/usr/bin:/usr/sbin:/bin:/sbin",
            refreshonly => true,
        }

        @ferm::rule { "dsa-ssh":
                description     => "Allow SSH from DSA",
                rule            => "proto tcp mod state state (NEW) dport (ssh) @subchain 'ssh' { saddr (\$SSH_SOURCES) ACCEPT; }"
        }
        @ferm::rule { "dsa-ssh-v6":
                description     => "Allow SSH from DSA",
                domain          => "ip6",
                rule            => "proto tcp mod state state (NEW) dport (ssh) @subchain 'ssh' { saddr (\$SSH_V6_SOURCES) ACCEPT; }"
        }
}
