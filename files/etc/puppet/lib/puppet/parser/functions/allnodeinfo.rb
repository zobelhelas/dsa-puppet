module Puppet::Parser::Functions
  newfunction(:allnodeinfo, :type => :rvalue) do |attributes|
    return Puppet::Parser::Functions::ldapinfo('*', attributes)
  end
end
