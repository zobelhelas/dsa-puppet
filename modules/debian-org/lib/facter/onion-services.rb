Facter.add("onion_hostname") do
	services = {}

	Dir['/var/lib/tor/onion/*/hostname'].each do |p|
		dir = File.dirname(p)
		service = File.basename(dir)
		hostname = IO.read(p).chomp
		services[service] = hostname
	end
	setcode do
		services
	end
end
