module Puppet::Parser::Functions
  newfunction(:onionbalance_hostname, :type => :rvalue) do |args|
    servicename = args.shift()

    onionbalance_hostname_fact = lookupvar('onionbalance_hostname')

    require 'json'
    parsed = JSON.parse(onionbalance_hostname_fact)
    return parsed[servicename]
  end
end
# vim:set ts=2:
# vim:set et:
# vim:set shiftwidth=2:
