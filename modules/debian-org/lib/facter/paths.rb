
%w{/srv/build-trees
   /srv/buildd
   /etc/ssh/ssh_host_ed25519_key
   /srv/mirrors/debian
   /srv/mirrors/debian-backports
   /srv/mirrors/debian-debug
   /srv/mirrors/debian-security
}.each do |path|
	Facter.add("has" + path.gsub('/','_')) do
		setcode do
			if FileTest.exist?(path)
				true
			else
				''
			end
		end
	end
end
