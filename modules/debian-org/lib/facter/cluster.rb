if FileTest.exist?('/usr/sbin/gnt-cluster') and FileTest.exist?('/var/lib/ganeti/config.data')
	begin
		if system('/usr/sbin/gnt-cluster getmaster >/dev/null')
			require 'yaml'
			yaml = YAML.load_file('/var/lib/ganeti/config.data')
			Facter.add('cluster') do
				setcode do
					yaml['cluster']['cluster_name']
				end
				Facter.add('cluster_nodes') do
					nodename = []
					yaml["nodes"].each do |uuid,value|
						nodename << value["name"]
					end
					ret = nodename.join(" ")
					setcode do
						ret
					end
				end
			end
		end
	rescue Exception => e
	end
end
