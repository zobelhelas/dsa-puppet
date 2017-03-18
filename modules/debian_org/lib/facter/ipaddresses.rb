Facter.add("v4ips") do
	confine :kernel => :linux
	addrs = []
	if FileTest.exist?("/bin/ip")
		%x{ip addr list}.each_line do |line|
			next unless line =~ /\s+inet/
			next if line =~ /scope (link|host)/
			if line =~ /\s+inet\s+(\S+)\/\d{1,2} .*/
				addrs << $1
			end
		end
	end
	ret = addrs.join(",")
	if ret.empty?
		ret = ''
	end
	setcode do
		ret
	end
end

Facter.add("v4ips") do
	confine :kernel => 'GNU/kFreeBSD'
	setcode do
		addrs = []
		output = %x{/sbin/ifconfig}

		output.split(/^\S/).each { |str|
			if str =~ /inet ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/
				tmp = $1
				unless tmp =~ /127\./
					addrs << tmp
					break
				end
			end
		}

		ret = addrs.join(",")
		if ret.empty?
			ret = ''
		end
		ret
	end
end

Facter.add("v6ips") do
	confine :kernel => :linux
	addrs = []
	if FileTest.exist?("/bin/ip")
		%x{ip addr list}.each_line do |line|
			next unless line =~ /\s+inet/
			next if line =~ /scope (link|host)/
			if line =~ /\s+inet6\s+(\S+)\/\d{1,3} .*/
				addrs << $1
			end
		end
	end
	ret = addrs.join(",")
	if ret.empty?
		ret = ''
	end
	setcode do
		ret
	end
end

