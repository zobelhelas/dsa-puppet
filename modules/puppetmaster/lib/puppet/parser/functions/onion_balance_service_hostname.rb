module Puppet::Parser::Functions
  newfunction(:onion_balance_service_hostname, :type => :rvalue) do |args|
    servicename = args.shift()

    onion_balance_service_hostname_fact = lookupvar('onion_balance_service_hostname')

    require 'json'
    parsed = JSON.parse(onion_balance_service_hostname_fact)
    return parsed[servicename]
  end
end
# vim:set ts=2:
# vim:set et:
# vim:set shiftwidth=2:
