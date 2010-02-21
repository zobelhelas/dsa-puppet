Facter.add("portforwarder") do
    setcode do
        key = nil
        keyfile = '/home/portforwarder/.ssh/id_rsa.pub'
        if FileTest.exist?(keyfile)
            key = File.open(keyfile).read.chomp
        end
        key
    end
end

# vim:set et:
# vim:set ts=4:
# vim:set shiftwidth=4:
