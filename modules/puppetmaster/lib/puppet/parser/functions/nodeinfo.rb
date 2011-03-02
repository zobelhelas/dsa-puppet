module Puppet::Parser::Functions
  newfunction(:nodeinfo, :type => :rvalue) do |args|

    host = args[0]
    yamlfile = args[1]

    require '/var/lib/puppet/lib/puppet/parser/functions/ldapinfo.rb'
    require '/var/lib/puppet/lib/puppet/parser/functions/whohosts.rb'

    results         = function_yamlinfo(host, yamlfile)
    results['ldap'] = function_ldapinfo(host, '*')
    unless results['ldap']['ipHostNumber']
      raise Puppet::ParseError, "Host #{host} does not have ipHostNumber values in ldap"
    end
    results['hoster'] = function_whohosts(results['ldap']['ipHostNumber'], "/etc/puppet/modules/debian-org/misc/hoster.yaml")

    results['misc'] = {}
    fqdn = lookupvar('fqdn')
    if fqdn and fqdn == host
      v4ips = lookupvar('v4ips')
      if v4ips
        results['misc']['v4addrs'] = v4ips.split(',')

        # find out if we are behind nat
        intersection = results['misc']['v4addrs'] & results['ldap']['ipHostNumber']
        results['misc']['natted'] = intersection.empty?
      end

      v6ips = lookupvar('v6ips')
      if v6ips and v6ips != "no"
        results['misc']['v6addrs'] = v6ips.split(',')
      end
    end

    if not nodeinfo['hoster']['nameservers'] or nodeinfo['hoster']['nameservers'].empty?
      # no nameservers known for this hoster
      results['misc']['resolver-recursive'] = true
    elsif (nodeinfo['hoster']['nameservers'] & nodeinfo['misc']['v4addrs']).size > 0 or
          (nodeinfo['hoster']['nameservers'] & nodeinfo['misc']['v6addrs']).size > 0
      # this host is listed as a nameserver at this location
      results['misc']['resolver-recursive'] = true
    else
      results['misc']['resolver-recursive'] = false
    end

    return(results)
  end
end

# vim: set fdm=marker ts=2 sw=2 et:
