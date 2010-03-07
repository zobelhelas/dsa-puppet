Facter.add("v4ips") do
        addrs = []
        %x{ip addr list}.each do |line|
                next unless line =~ /\s+inet/
                next if line =~ /scope (link|host)/
                if line =~ /\s+inet\s+(\S+)\/\d\d .*/
                        addrs << $1
                end
        end
        setcode do
                addrs.join(",")
        end
end

Facter.add("v6ips") do
        addrs = []
        %x{ip addr list}.each do |line|
                next unless line =~ /\s+inet/
                next if line =~ /scope (link|host)/
                if line =~ /\s+inet6\s+(\S+)\/\d\d .*/
                        addrs << $1
                end
        end
        setcode do
                addrs.join(",")
        end
end

