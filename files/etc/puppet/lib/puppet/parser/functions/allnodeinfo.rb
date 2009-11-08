module Puppet::Parser::Functions
  newfunction(:allnodeinfo, :type => :rvalue) do |attributes|

    unless attributes.include?('hostname')
      attributes << 'hostname'
    end

    ldap = LDAP::Conn.new('db.debian.org')

    results = []
    filter = '(hostname=*)'
    begin
      ldap.search2('ou=hosts,dc=debian,dc=org', LDAP::LDAP_SCOPE_SUBTREE, filter, attrs=attributes, false, 0, 0, s_attr="hostname") do |x|
        results << x
      end
    rescue LDAP::ResultError
    rescue RuntimeError
    ensure
      ldap.unbind
    end
    return(results)
  end
end
