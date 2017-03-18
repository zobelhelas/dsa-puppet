Facter.add(:operatingsystem) do
    confine :kernel => 'GNU/kFreeBSD'
    setcode do
        if FileTest.exists?("/etc/debian_version")
            "Debian"
	end
    end
end
