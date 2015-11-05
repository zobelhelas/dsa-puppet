module Puppet::Parser::Functions
  newfunction(:gen_tlsa_entry, :type => :rvalue) do |args|
    certfile = args.shift()
    hostname = args.shift()
    port = args.shift()

    if port.kind_of?(String)
      ports = port.split()
    else
      ports = port
    end

    res = []
    res << "; cert #{certfile} for #{hostname}:#{ports}."
    ports.each { |port|
      cf = certfile
      if File.exist?(cf)
        cmd = ['swede', 'create', '--usage=3', '--selector=1', '--mtype=1', '--certificate', cf, '--port', port.to_s, hostname]
        IO.popen(cmd, "r") {|i| res << i.read }
      else
        res << "; certfile #{cf} did not exist to create TLSA record for #{hostname}:#{port}."
      end

      if cf.gsub!(/\.crt$/, '-new.crt') and File.exist?(cf)
        cmd = ['swede', 'create', '--usage=3', '--selector=1', '--mtype=1', '--certificate', cf, '--port', port.to_s, hostname]
        new_entry = ''
        IO.popen(cmd, "r") {|i| new_entry = i.read }
        if not res.include?(new_entry)
          res << new_entry
        end
      end
    }

    return res.join("\n")
  end
end
