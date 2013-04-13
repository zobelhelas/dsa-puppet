Facter.add("systemproductname") do
	confine :kernel => :linux
	setcode do
		%x{dmidecode -s system-product-name}.chomp.strip
	end
end
