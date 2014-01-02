module Puppet::Parser::Functions
  newfunction(:has_role, :type => :rvalue) do |args|
      role = args.shift
      roles = lookupvar('site::roles')
      fqdn = lookupvar('fqdn')
      if not roles.include?(role)
        err "Failed to look up missing role #{role}"
        return false
      end
      return roles[role].include?(fqdn)
    end
end
