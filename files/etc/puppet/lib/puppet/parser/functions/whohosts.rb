module Puppet::Parser::Functions
  newfunction(:whohosts, :type => :rvalue) do |args|
    require 'ipaddr'
    require 'yaml'

    nodeinfo = args[0]
    yamlfile = args[1]
    parser.watch_file(yamlfile)

    $KCODE = 'utf-8'

    ans = "unknown"
    yaml = YAML.load_file(yamlfile)

    if (nodeinfo['ldap'].at(0)) and (nodeinfo['ldap'][0].has_key?('ipHostNumber'))
      nodeinfo['ldap'][0]['ipHostNumber'].each do |addr|
        yaml.keys.each do |hoster|
          yaml[hoster].each do |net|
            if IPAddr.new(net).include?(addr)
              ans = hoster
            end
          end
        end
      end
    end
    return ans
  end
end
