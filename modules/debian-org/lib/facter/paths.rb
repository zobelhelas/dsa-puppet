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
