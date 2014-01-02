module Puppet::Parser::Functions
  newfunction(:has_role, :type => :rvalue) do |args|
    begin
      role = args.shift
      roles = lookupvar('site::roles')
      fqdn = lookupvar('fqdn')
      return roles[role].include?(fqdn)
    end
  end
end
