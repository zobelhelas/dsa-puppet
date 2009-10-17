Facter.add("apache2") do
	setcode do
		FileTest.exist?("/usr/sbin/apache2")
	end
end
Facter.add("clamd") do
	setcode do
		FileTest.exist?("/usr/sbin/clamd")
	end
end
Facter.add("exim4") do
	setcode do
		FileTest.exist?("/usr/sbin/exim4")
	end
end
Facter.add("postfix") do
	setcode do
		FileTest.exist?("/usr/sbin/postfix")
	end
end
Facter.add("postgres81") do
	setcode do
		FileTest.exist?("/usr/lib/postgresql/8.1/bin/postgres")
	end
end
Facter.add("postgres83") do
	setcode do
		FileTest.exist?("/usr/lib/postgresql/8.3/bin/postgres")
	end
end
Facter.add("postgrey") do
	setcode do
		FileTest.exist?("/usr/sbin/postgrey")
	end
end
Facter.add("greylistd") do
	setcode do
		FileTest.exist?("/usr/sbin/greylistd")
	end
end
Facter.add("policydweight") do
	setcode do
		FileTest.exist?("/usr/sbin/policyd-weight")
	end
end
Facter.add("vsftpd") do
	setcode do
		FileTest.exist?("/usr/sbin/vsftpd")
	end
end
