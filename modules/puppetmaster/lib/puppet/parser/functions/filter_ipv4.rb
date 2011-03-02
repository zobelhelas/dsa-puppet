module Puppet::Parser::Functions
  # given an array of network addresses, return only the ipv4 addresses
  newfunction(:filter_ipv4, :type => :rvalue) do |args|
    x = args.shift

    raise Puppet::ParseError, "Argument is not an array." unless x.kind_of?(Array)
    return x.reject{ |x| x =~ /:/}
  end
end
# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
