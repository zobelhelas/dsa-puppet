Facter.add("has-srv-build-trees") do
	setcode do
		if FileTest.exist?("/srv/build-trees")
			true
		else
			''
		end
	end
end
Facter.add("has-srv-buildd") do
	setcode do
		if FileTest.exist?("/srv/buildd")
			true
		else
			''
		end
	end
end
