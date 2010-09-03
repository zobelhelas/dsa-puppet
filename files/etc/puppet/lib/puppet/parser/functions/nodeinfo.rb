module Puppet::Parser::Functions
  newfunction(:nodeinfo, :type => :rvalue) do |args|

    host = args[0]
    yamlfile = args[1]

    require '/etc/puppet/lib/puppet/parser/functions/ldapinfo.rb'

    results         = function_yamlinfo(host, yamlfile)
    results['ldap'] = function_ldapinfo(host, '*')

    results['misc'] = {}
    fqdn = lookupvar('fqdn')
    if fqdn and fqdn == host
      v4ips = lookupvar('v4ips')
      if v4ips
        # find out if we are behind nat
        v4addrs = v4ips.split(',')
        intersection = v4addrs & results['ldap']['ipHostNumber']
        results['misc']['natted'] = intersection.empty?
      end
    end

    return(results)
  end
end

# vim: set fdm=marker ts=2 sw=2 et:
