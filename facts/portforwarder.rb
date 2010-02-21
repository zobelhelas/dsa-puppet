begin
    require 'etc'

    Facter.add("portforwarder-key") do
        setcode do
            key = nil
            keyfile = '/home/portforwarder/.ssh/id_rsa.pub'
            if FileTest.exist?(keyfile)
                key = File.open(keyfile).read.chomp
            end
            key
        end
    end

    Facter.add("portforwarder-user-exists") do
        setcode do
            result = false
            begin
                if Etc.getpwnam('portforwarder')
                    result = true
                end
            rescue ArgumentError
            end
            result
        end
    end

rescue Exception => e
end
# vim:set et:
# vim:set ts=4:
# vim:set shiftwidth=4:
