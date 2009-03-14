begin
  require 'filesystem'
rescue Exception => e
  exit 0
end

Facter.add("mounts") do
	ignorefs = ["NFS", "nfs", "nfs4", "afs", "binfmt_misc", "proc", "smbfs", 
		    "autofs", "iso9660", "ncpfs", "coda", "devpts", "ftpfs", "devfs", 
		    "mfs", "shfs", "sysfs", "cifs", "lustre_lite", "tmpfs", "usbfs", "udf"]
	mountpoints = []
	FileSystem.mounts.each do |m|
		if not ignorefs.include?(m.fstype) && m.options !~ /bind/
			mountpoints << m.mount
		end
	end
	setcode do
		mountpoints.join(',')
	end
end

