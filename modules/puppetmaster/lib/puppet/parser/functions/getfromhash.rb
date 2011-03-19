module Puppet::Parser::Functions
  newfunction(:getfromhash, :type => :rvalue) do |args|
    x = args.shift
    keys = args
    keys_done = []

    # allows getting of hash[key] or even hash[key1][key2] etc.
    keys.each do |key|
      raise Puppet::ParseError, "argument[#{keys_done.join('][')}] is not a hash." unless x.kind_of?(Hash)
      unless x.has_key?(key)
        x = false
        break
      end
      x = x[key]
      keys_done << key
    end

    return x
  end
end
# vim:set et:
# vim:set sts=2 ts=2:
# vim:set shiftwidth=2:
