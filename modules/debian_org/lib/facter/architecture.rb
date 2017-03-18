Facter.add(:architecture) do
    confine :kernel => 'GNU/kFreeBSD'
    setcode do
        model = Facter.value(:hardwaremodel)
        case model
        when 'x86_64' then "amd64"
        when /(i[3456]86|pentium)/ then "i386"
        else
            model
        end
    end
end

Facter.add(:debarchitecture) do
    setcode do
        %x{/usr/bin/dpkg --print-architecture}.chomp
    end
end

