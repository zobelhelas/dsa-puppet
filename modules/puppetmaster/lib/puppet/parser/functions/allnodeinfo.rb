module Puppet::Parser::Functions
  newfunction(:allnodeinfo, :type => :rvalue) do |attributes|
    attributes.unshift('*')
    return (function_ldapinfo(attributes))
  end
end
