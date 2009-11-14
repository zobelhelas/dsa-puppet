module Puppet::Parser::Functions
  newfunction(:allnodeinfo, :type => :rvalue) do |attributes|
    return function_ldapinfo('*', attributes)
  end
end
