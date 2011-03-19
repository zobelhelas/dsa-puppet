module Puppet::Parser::Functions
  # given an list, join with spaces
  newfunction(:join_spc, :type => :rvalue) do |args|
    x = args.shift

    raise Puppet::ParseError, "Argument is not an array." unless x.kind_of?(Array)
    return x.join(' ')
  end
end
# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
