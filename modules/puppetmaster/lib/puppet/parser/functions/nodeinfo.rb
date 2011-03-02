module Puppet::Parser::Functions
  newfunction(:nodeinfo, :type => :rvalue) do |args|

    host = args[0]
    yamlfile = args[1]

    require '/var/lib/puppet/lib/puppet/parser/functions/ldapinfo.rb'
    require '/var/lib/puppet/lib/puppet/parser/functions/whohosts.rb'

    nodeinfo         = function_yamlinfo(host, yamlfile)
    nodeinfo['ldap'] = function_ldapinfo(host, '*')
    unless nodeinfo['ldap']['ipHostNumber']
      raise Puppet::ParseError, "Host #{host} does not have ipHostNumber values in ldap"
    end
    nodeinfo['hoster'] = function_whohosts(nodeinfo['ldap']['ipHostNumber'], "/etc/puppet/modules/debian-org/misc/hoster.yaml")

    nodeinfo['misc'] = {}
    fqdn = lookupvar('fqdn')
    if fqdn and fqdn == host
      v4ips = lookupvar('v4ips')
      if v4ips
        nodeinfo['misc']['v4addrs'] = v4ips.split(',')

        # find out if we are behind nat
        intersection = nodeinfo['misc']['v4addrs'] & nodeinfo['ldap']['ipHostNumber']
        nodeinfo['misc']['natted'] = intersection.empty?
      end

      v6ips = lookupvar('v6ips')
      if v6ips and v6ips != "no"
        nodeinfo['misc']['v6addrs'] = v6ips.split(',')
      end
    end

    if not nodeinfo['hoster']['nameservers'] or nodeinfo['hoster']['nameservers'].empty?
      # no nameservers known for this hoster
      nodeinfo['misc']['resolver-recursive'] = true

      if nodeinfo['hoster']['allow_dns_query']
        raise Puppet::ParseError, "No nameservers listed for #{nodeinfo['hoster']['name']} yet we should answer somebody's queries?  That makes no sense."
      end
    elsif (nodeinfo['hoster']['nameservers'] & nodeinfo['misc']['v4addrs']).size > 0 or
          (nodeinfo['hoster']['nameservers'] & nodeinfo['misc']['v6addrs']).size > 0
      # this host is listed as a nameserver at this location
      nodeinfo['misc']['resolver-recursive'] = true

      if not nodeinfo['hoster']['allow_dns_query'] or nodeinfo['hoster']['allow_dns_query'].empty?
        raise Puppet::ParseError, "Host #{host} is listed as a nameserver for #{nodeinfo['hoster']['name']} but no allow_dns_query networks are defined for this location"
      end
    else
      nodeinfo['misc']['resolver-recursive'] = false
    end

    return(nodeinfo)
  end
end

# vim: set fdm=marker ts=2 sw=2 et:
