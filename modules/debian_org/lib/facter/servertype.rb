Facter.add("kvmdomain") do
	setcode do
		result = false
		if File.new('/proc/cpuinfo').read().index('hypervisor')
			result = true
		end
		result
	end
end
