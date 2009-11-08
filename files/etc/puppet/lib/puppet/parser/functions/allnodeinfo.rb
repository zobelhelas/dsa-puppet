module Puppet::Parser::Functions
  newfunction(:allnodeinfo, :type => :rvalue) do |attributes|

    unless attributes.include?('hostname')
      attributes << 'hostname'
    end

    ldap = LDAP::SSLConn.new('db.debian.org', 636)

    results = []
    filter = '(hostname=*)'
    begin
      ldap.search2('ou=hosts,dc=debian,dc=org', LDAP::LDAP_SCOPE_SUBTREE, filter, attrs=attributes, false, 0, 0, s_attr="hostname") do |x|
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
