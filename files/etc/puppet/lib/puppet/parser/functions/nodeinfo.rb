module Puppet::Parser::Functions
  newfunction(:nodeinfo, :type => :rvalue) do |args|

    host = args[0]
    yamlfile = args[1]

    require '/etc/puppet/lib/puppet/parser/functions/ldapinfo.rb'
    require '/etc/puppet/lib/puppet/parser/functions/yamlinfo.rb'

    results         = function_yamlinfo(host, yamlfile)
    results['ldap'] = function_ldapinfo(host, '*')
    return(results)
  end
end

# vim: set fdm=marker ts=2 sw=2 et:
