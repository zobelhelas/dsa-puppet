module Puppet::Parser::Functions
  newfunction(:allnodeinfo, :type => :rvalue) do |attributes|

    unless attributes.include?('hostname')
      attributes << 'hostname'
    end

    ldap = LDAP::SSLConn.new('db.debian.org', 636)

    results = []
    filter = '(hostname=*)'
    begin
      ldap.search2('ou=hosts,dc=debian,dc=org', LDAP::LDAP_SCOPE_SUBTREE, filter, attrs=attributes, false, 0, 0, s_attr="hostname").each do |x|
        # If a returned value doesn't have all the attributes we're searching for, skip
        attributes.each do |a|
          # We'll skip if the array is empty, but we also seem to get back a nil object for empty attributes sometimes
          begin
            next if x[a].empty?
          rescue NoMethodError
            next
          end
        end
        results << x
      end
    rescue LDAP::ResultError
      raise Puppet::ParseError, "LDAP error"
    rescue RuntimeError
      raise Puppet::ParseError, "No data returned from search"
    ensure
      ldap.unbind
    end
    return(results)
  end
end
