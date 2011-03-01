module Puppet::Parser::Functions
  newfunction(:getfromhash, :type => :rvalue) do |args|
    h = args.shift
    key = args.shift

    raise Puppet::ParseError, "argument is not a hash" unless h.kind_of?(Hash)
    if h.has_key?(key)
      ans = h[key]
    else
      ans = false
    end

    return ans
  end
end
# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
