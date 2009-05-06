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

    if yaml.has_key?('services')
      ['bugsmaster', 'qamaster', 'mailrelay', 'rtmaster', 'packagesmaster'].each do |service|
        if yaml['services'].has_key?(service)
          results[service] = host == yaml['services'][service]
        end
      end
    end

    if yaml.has_key?('need_smarthost') and yaml['need_smarthost'].include?(host)
      results['smarthost']      = "mailout.debian.org"
      results['smarthost_port'] = 587
    else
      results['smarthost']      = ''
      results['smarthost_port'] = ''
    end

    results['reservedaddrs'] = case host
      when "ball.debian.org"
        '0.0.0.0/8 : 127.0.0.0/8 : 169.254.0.0/16 : 172.16.0.0/12 : 192.0.0.0/17 : 192.168.0.0/16 : 224.0.0.0/4 : 240.0.0.0/5 : 248.0.0.0/5'
      else
        '0.0.0.0/8 : 127.0.0.0/8 : 10.0.0.0/8 : 169.254.0.0/16 : 172.16.0.0/12 : 192.0.0.0/17 : 192.168.0.0/16 : 224.0.0.0/4 : 240.0.0.0/5 : 248.0.0.0/5'
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
