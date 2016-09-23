module Puppet::Parser::Functions
  newfunction(:gen_hpkp_pin, :type => :rvalue) do |args|
    site = args.shift()

    pin_info = []
    pinfiles = [ "/srv/puppet.debian.org/from-letsencrypt/#{site}.pin",
                 "/srv/puppet.debian.org/backup-keys/#{site}.pin" ]
    pinfiles.each do |fn|
      if File.exist?(fn)
        pin_info << File.read(fn).chomp()
      end
    end

    res = []
    res << "<Macro http-pkp-#{site}>"
    if pin_info.size >= 2 then
      pin_info = pin_info.map{ |x| x.gsub('"', '\"') }
      pin_info << "max-age=300"
      pin_str = pin_info.join("; ")
      res << "  Header always set Public-Key-Pins \"#{pin_str}\""
    else
      res << "  # mod macro does not like empty macros, so here's some content:"
      res << "  <Directory /non-existant>"
      res << "  </Directory>"
    end
    res << "</Macro>"
    res << ""
    return res.join("\n")
  end
end
