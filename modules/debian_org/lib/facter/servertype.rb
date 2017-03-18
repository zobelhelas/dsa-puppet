Facter.add("kvmdomain") do
	setcode do
		result = false
		if File.new('/proc/cpuinfo').read().index('QEMU Virtual CPU')
			result = true
		end
		result
	end
end
