module Puppet::Parser::Functions
  newfunction(:allnodeinfo, :type => :rvalue) do |attributes|
    return ldapinfo('*', attributes)
  end
end
