Facter.add("raidcontroller") do
        confine :kernel => :linux
        ENV["PATH"]="/bin:/sbin:/usr/bin:/usr/sbin"
        setcode do
                ishp = False
                lspciexists = system "/bin/bash -c 'which lspci >&/dev//null'"
                if $?.exitstatus == 0
                        output = %x{lspci}
                        output.each { |s|
                                ishp == True if s =~ /RAID bus controller: (.*) Smart Array/
                        }
                end
                ishp
        end
end
