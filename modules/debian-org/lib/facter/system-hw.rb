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
