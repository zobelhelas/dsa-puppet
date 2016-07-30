# This function returns the .onion name for a given service name on Debian's onionbalance instance
# for this, it reads /srv/puppet.debian.org/puppet-facts/onionbalance-services.yaml
# this comes from the onionbalance-host, via puppet's storedconf
#
module Puppet::Parser::Functions
  newfunction(:onion_global_service_hostname, :type => :rvalue) do |args|
    servicename = args.shift()

    fn = '/srv/puppet.debian.org/puppet-facts/onionbalance-services.yaml'
    unless File.exist?(fn)
      return false
    end

    facts = IO.read(fn)

    require 'json'
    parsed = {}
    facts.each_line do |l|
      p.update(JSON.parse(l))
    end
    return parsed[servicename]
  end
end
# vim:set ts=2:
# vim:set et:
# vim:set shiftwidth=2:
