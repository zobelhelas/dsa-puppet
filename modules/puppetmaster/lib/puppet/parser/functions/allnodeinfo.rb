module Puppet::Parser::Functions
  newfunction(:allnodeinfo, :type => :rvalue) do |args|
    begin
      required = args.shift.split()
      optional = args.shift.split()

      allhosts = function_ldapinfo(['*', *(required+optional) ])
      res = {}
      allhosts.each_pair do |hostname, host|
          # If a returned value doesn't have all the attributes we're searching for, skip
          # We'll skip if the array is empty, but we also seem to get back a nil object for empty attributes sometimes
          next if required.any?{ |a| not host[a] or host[a].empty? }
          res[hostname] = host
      end

      return res
    rescue => e
      raise Puppet::ParseError, "Error in allnodeinfo: #{e.message}\n#{e.backtrace}"
    end
  end
end
# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
