Facter.add("systemproductname") do
	confine :kernel => :linux
	setcode do
		if FileTest.exist?("/usr/sbin/dmidecode")
			%x{/usr/sbin/dmidecode -s system-product-name}.chomp.strip
		else
			''
		end
	end
end

Facter.add("hw_can_temp_sensors") do
	confine :kernel => :linux
	setcode do
		if FileTest.exist?("/sys/devices/virtual/thermal/thermal_zone0/temp")
			true
		else
			''
		end
	end
end
