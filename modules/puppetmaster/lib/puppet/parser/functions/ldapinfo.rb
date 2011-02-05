module Puppet::Parser::Functions
  newfunction(:ldapinfo, :type => :rvalue) do |attributes|

    host = attributes.shift

    unless attributes.include?("*") or attributes.include?('hostname')
      attributes << 'hostname'
    end

    require 'ldap'
    ldap = LDAP::SSLConn.new('db.debian.org', 636)

    results = {}
    filter = '(hostname=' + host + ')'
    begin
      ldap.search2('ou=hosts,dc=debian,dc=org', LDAP::LDAP_SCOPE_SUBTREE, filter, attrs=attributes, false, 0, 0, s_attr="hostname").each do |x|
        # If a returned value doesn't have all the attributes we're searching for, skip
        # We'll skip if the array is empty, but we also seem to get back a nil object for empty attributes sometimes
        unless attributes.include?("*")
          next if attributes.any?{ |a|  not x[a] or x[a].empty? }
        end
        results[x['hostname'][0]] = x
      end
    rescue LDAP::ResultError
      raise Puppet::ParseError, "LDAP error"
    rescue RuntimeError
      raise Puppet::ParseError, "No data returned from search"
    ensure
      ldap.unbind
    end
    if host == '*'
      return(results)
    else
      return(results[host])
    end
  end
end
