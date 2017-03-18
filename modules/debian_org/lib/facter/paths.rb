
%w{/srv/build-trees
   /srv/buildd
   /etc/ssh/ssh_host_ed25519_key
   /srv/mirrors/debian
   /srv/mirrors/debian-debug
   /srv/mirrors/debian-ports
   /srv/mirrors/debian-security
   /dev/hwrng
}.each do |path|
	Facter.add("has" + path.gsub(/[\/-]/,'_')) do
		setcode do
			if FileTest.exist?(path)
				true
			else
				false
			end
		end
	end
end
