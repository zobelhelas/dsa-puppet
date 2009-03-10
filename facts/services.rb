["bugs","qa"].each do |service|
	Facter.add(service + "_host") do
		service_name = "#{service}." + Facter.domain
		active = false

		setcode do
			if FileTest.exist?("/usr/bin/dig")
				%x{/usr/bin/dig +short -t a #{service_name}}.chomp.each do |service_ip|
					Facter.interfaces.split(',').each do |my_interface|
						my_ip = Facter.value("ipaddress_" + my_interface)
						if my_ip == service_ip
							active = "true"
						end
					end
				end
			end
			active
		end
	end
end
