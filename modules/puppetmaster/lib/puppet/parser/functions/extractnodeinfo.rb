module Puppet::Parser::Functions
  newfunction(:extractnodeinfo, :type => :rvalue) do |args|

    nodeinfo = args.shift

    ni = nodeinfo
    keys_done = []

    args.each do |key|
      raise Puppet::ParseError, "nodeinfo is not a hash at #{keys_done.join('->')}" unless ni.kind_of?(Hash)
      unless ni.has_key?(key)
        ni = false
        break
      end
      ni = ni[key]
      keys_done << key
    end
    return ni
  end
end
# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
