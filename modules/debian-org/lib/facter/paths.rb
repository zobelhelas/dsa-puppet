Facter.add("has_srv_build_trees") do
	setcode do
		if FileTest.exist?("/srv/build-trees")
			true
		else
			''
		end
	end
end
Facter.add("has_srv_buildd") do
	setcode do
		if FileTest.exist?("/srv/buildd")
			true
		else
			''
		end
	end
end
Facter.add("has_srv_buildd") do
	setcode do
		if FileTest.exist?("/srv/buildd")
			true
		else
			''
		end
	end
end
Facter.add("has_etc_ssh_ssh_host_ed25519_key") do
	setcode do
		if FileTest.exist?("/etc/ssh/ssh_host_ed25519_key")
			true
		else
			''
		end
	end
end
