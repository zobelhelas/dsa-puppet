Facter.add("systemproductname") do
	confine :kernel => :linux
	setcode do
		%x{dmidecode -s system-product-name}.chomp
	end
end
