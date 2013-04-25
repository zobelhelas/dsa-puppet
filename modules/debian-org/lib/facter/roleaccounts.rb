begin
    require 'etc'

    Facter.add("staticsync_key") do
        setcode do
            key = nil
            keyfile = '/home/staticsync/.ssh/id_rsa.pub'
            if FileTest.exist?(keyfile)
                key = File.open(keyfile).read.chomp
            end
            key
        end
    end

    Facter.add("staticsync_user_exists") do
        setcode do
            result = ''
            begin
                if Etc.getpwnam('staticsync')
                    result = true
                end
            rescue ArgumentError
            end
            result
        end
    end



    Facter.add("weblogsync_key") do
        setcode do
            key = nil
            keyfile = '/home/weblogsync/.ssh/id_rsa.pub'
            if FileTest.exist?(keyfile)
                key = File.open(keyfile).read.chomp
            end
            key
        end
    end

    Facter.add("weblogsync_user_exists") do
        setcode do
            result = ''
            begin
                if Etc.getpwnam('weblogsync')
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
