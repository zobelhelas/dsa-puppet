module Puppet::Parser::Functions
  newfunction(:has_role, :type => :rvalue) do |args|
    begin
      role = args.shift
      roles = lookupvar('site::roles')
      fqdn = lookupvar('fqdn')
      return fqdn in roles[role]
    end
  end
end
