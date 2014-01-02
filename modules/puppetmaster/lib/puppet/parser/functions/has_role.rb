module Puppet::Parser::Functions
  newfunction(:has_role, :type => :rvalue) do |args|
    begin
      role = args.shift
      roles = lookupvar('site::roles')
      fqdn = lookupvar('fqdn')
      if not roles.include?(role)
        error "Failed to look up missing role #{role}"
        return False
      end
      return roles[role].include?(fqdn)
    end
  end
end
