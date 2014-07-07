if FileTest.exist?('/usr/sbin/gnt-cluster') and FileTest.exist?('/var/lib/ganeti/ssconf_cluster_name')
	begin
		if system('/usr/sbin/gnt-cluster getmaster >/dev/null')
			Facter.add('cluster') do
				setcode do
					open('/var/lib/ganeti/ssconf_cluster_name').read().chomp()
				end
			end
			Facter.add('cluster_nodes') do
				setcode do
					open('/var/lib/ganeti/ssconf_node_list').read().split()
				end
			end
		end
	rescue Exception => e
	end
end
