Facter.add("system-product-name") do
	confine :kernel => :linux
	setcode do
		%x{dmidecode -s system-product-name}.chomp
	end
end
