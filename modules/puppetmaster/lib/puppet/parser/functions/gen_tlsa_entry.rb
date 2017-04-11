module Puppet::Parser::Functions
  newfunction(:gen_tlsa_entry, :type => :rvalue) do |args|
    certfile = args.shift()
    hostname = args.shift()
    port = args.shift()

    if port.kind_of?(Array)
      ports = port
    else
      ports = [port]
    end

    if certfile.kind_of?(Array)
      certs = certfile
    else
      certs = [ certfile ]
    end

    res = []
    certs.each do |certfile|
      res << "; cert #{certfile} for #{hostname}:#{ports}."
      ports.each do |port|
        if File.exist?(certfile)
          cmd = ['swede', 'create', '--usage=3', '--selector=1', '--mtype=1', '--certificate', certfile, '--port', port.to_s, hostname]
          begin
            IO.popen(cmd, "r") {|i| res << i.read }
          rescue Errno::ENOENT
            res << "; Failed to find swede"
          end
        else
          res << "; certfile #{certfile} did not exist to create TLSA record for #{hostname}:#{port}."
        end

        cfnew = certfile.gsub(/\.crt$/, '-new.crt')
        if cfnew != certfile and File.exist?(cfnew)
          cmd = ['swede', 'create', '--usage=3', '--selector=1', '--mtype=1', '--certificate', cfnew, '--port', port.to_s, hostname]
          new_entry = ''
          IO.popen(cmd, "r") {|i| new_entry = i.read }
          if not res.include?(new_entry)
            res << new_entry
          end
        end
      end
    end

    return res.join("\n")
  end
end
