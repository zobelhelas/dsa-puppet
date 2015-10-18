class roles::weblog_provider {
	if ! $::weblogsync_key {
		exec { 'create-weblogsync-key':
			command => '/bin/su - weblogsync -c \'mkdir -p -m 02700 .ssh && ssh-keygen -C "`whoami`@`hostname` (`date +%Y-%m-%d`)" -P "" -f .ssh/id_rsa -q\'',
			onlyif  => '/usr/bin/getent passwd weblogsync > /dev/null && ! [ -e /home/weblogsync/.ssh/id_rsa ]'
		}
	} else {
		file { '/etc/cron.d/puppet-weblog-provider':
			content => "SHELL=/bin/bash\n\n0 */4 * * * weblogsync sleep $((RANDOM \% 1800)); rsync -a --delete-excluded --include '*-public-access.log-*gz' --exclude '**' /var/log/apache2/. weblogsync@wolkenstein.debian.org:-weblogs-incoming-\n",
		}
	}
}
