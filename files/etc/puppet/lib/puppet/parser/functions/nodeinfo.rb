module Puppet::Parser::Functions
  newfunction(:nodeinfo, :type => :rvalue) do |args|

    host = args[0]
    yamlfile = args[1]
    parser.watch_file(yamlfile)

    require 'ldap'
    require 'yaml'

    $KCODE = 'utf-8'

    yaml = YAML.load_file(yamlfile)
    results = {}

    ['nameinfo', 'footer'].each do |detail|
      if yaml.has_key?(detail)
        if yaml[detail].has_key?(host)
          results[detail] = yaml[detail][host]
        end
      end
    end

    ldap = LDAP::Conn.new('db.debian.org')

    results['ldap'] = []
    filter = '(hostname=' + host +')'
    begin
      ldap.search2('ou=hosts,dc=debian,dc=org', LDAP::LDAP_SCOPE_SUBTREE, filter) do |x|
        results['ldap'] << x
      end
    rescue LDAP::ResultError
    rescue RuntimeError
    ensure
      ldap.unbind
    end
    return(results)
  end
end
