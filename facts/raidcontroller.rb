Facter.add("raidcontroller") do
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
        ENV["PATH"]="/bin:/sbin:/usr/bin:/usr/sbin"
        setcode do
                FileTest.exist?("/proc/mpt/info")
        end
end
