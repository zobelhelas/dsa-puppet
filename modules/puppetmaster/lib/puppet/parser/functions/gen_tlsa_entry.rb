module Puppet::Parser::Functions
  newfunction(:gen_tlsa_entry, :type => :rvalue) do |args|
    certfile = args.shift()
    hostname = args.shift()
    port = args.shift()

    res = []
    if File.exist?(certfile)
      cmd = ['swede', 'create', '--usage=3', '--selector=1', '--mtype=1', '--certificate', certfile, '--port', port.to_s, hostname]
      IO.popen(cmd, "r") {|i| res << i.read }
    else
      res << "; certfile #{certfile} did not exist to create TLSA record for #{hostname}:#{port}."
    end

    certfile += ".new"
    if File.exist?(certfile)
      cmd = ['swede', 'create', '--usage=3', '--selector=1', '--mtype=1', '--certificate', certfile, '--port', port.to_s, hostname]
      IO.popen(cmd, "r") {|i| res << i.read }
    end

    return res.join("\n")
  end
end
