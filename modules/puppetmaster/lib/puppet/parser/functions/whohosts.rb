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

    if (nodeinfo['ldap'].has_key?('ipHostNumber'))
      nodeinfo['ldap']['ipHostNumber'].each do |addr|
        yaml.keys.each do |hoster|
          if yaml[hoster].has_key?'netrange'
            yaml[hoster]['netrange'].each do |net|
              if IPAddr.new(net).include?(addr)
                return hoster
              end
            end
          end
        end
      end
    end
    return ans
  end
end
# vim:set ts=2:
# vim:set et:
# vim:set shiftwidth=2:
