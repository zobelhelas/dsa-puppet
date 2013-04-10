Facter.add("smartarraycontroller") do
	confine :kernel => :linux
	setcode do
		if FileTest.exist?("/dev/cciss/")
			true
		elsif FileTest.exist?("/sys/module/hpsa/")
			true
		else
			''
		end
	end
end

Facter.add("ThreeWarecontroller") do
	confine :kernel => :linux
	setcode do
		is3w = ''
		if FileTest.exist?("/proc/scsi/scsi")
			IO.foreach("/proc/scsi/scsi") { |x|
				is3w = true if x =~ /Vendor: 3ware/
			}
		end
		is3w
	end
end

Facter.add("megaraid") do
	confine :kernel => :linux
	setcode do
		if FileTest.exist?("/dev/megadev0")
			true
		else
			''
		end
	end
end

Facter.add("mptraid") do
	confine :kernel => :linux
	setcode do
		if FileTest.exist?("/dev/mptctl") or FileTest.exist?("/dev/mpt0") or FileTest.exist?("/proc/mpt/summary")
			true
		else
			''
		end
	end
end

Facter.add("aacraid") do
	confine :kernel => :linux
	setcode do
		if FileTest.exist?("/dev/aac0")
			true
		else
			''
		end
	end
end

Facter.add("swraid") do
	confine :kernel => :linux
	setcode do
                swraid = ''
		if FileTest.exist?("/proc/mdstat") && FileTest.exist?("/sbin/mdadm")
                        IO.foreach("/proc/mdstat") { |x|
                                swraid = true if x =~ /md[0-9]+ : active/
                        }
                end
                swraid
	end
end

