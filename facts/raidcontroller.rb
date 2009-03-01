Facter.add("smartarraycontroller") do
	confine :kernel => :linux
	ENV["PATH"]="/bin:/sbin:/usr/bin:/usr/sbin"
	setcode do
		ishp = "false"
		lspciexists = system "/bin/bash -c 'which lspci >&/dev//null'"
		if $?.exitstatus == 0
			%x{lspci}.each { |s|
				ishp = "true" if s =~ /RAID bus controller: (.*) Smart Array/
			}
		end
		ishp
	end
end

Facter.add("mptcontroller") do
	confine :kernel => :linux
	setcode do
		FileTest.exist?("/proc/mpt/summary")
	end
end

Facter.add("3warecontroller") do
	confine :kernel => :linux
	setcode do
		is3w = "false"
		if FileTest.exist?("/proc/scsi/scsi")
			IO.foreach("/proc/scsi/scsi") { |x|
				is3w = "true" if x =~ /Vendor: 3ware/
			}
		end
		is3w
	end
end
