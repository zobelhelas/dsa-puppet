module Puppet::Parser::Functions
  newfunction(:entropy_provider, :type => :rvalue) do |args|
    begin
      require '/var/lib/puppet/lib/puppet/parser/functions/whohosts.rb'

      fqdn = args[0]
      nodeinfo = args[1]

      localinfo = lookupvar('localinfo')
      allnodeinfo = lookupvar('allnodeinfo')

      raise Puppet::ParseError, "entropy_provider: Cannot learn fqdn" unless fqdn
      raise Puppet::ParseError, "entropy_provider: Cannot learn nodeinfo" unless nodeinfo
      raise Puppet::ParseError, "entropy_provider: Cannot learn localinfo" unless localinfo
      raise Puppet::ParseError, "entropy_provider: Cannot learn allnodeinfo" unless allnodeinfo

      # find where all the entropy keys are
      provider = []
      hoster = {}
      localinfo.keys.sort.each do |node|
        next unless  localinfo[node]['entropy_key']

        addresses = allnodeinfo[node]['ipHostNumber']
        thishoster = function_whohosts(addresses, "/etc/puppet/modules/debian-org/misc/hoster.yaml")
        name = thishoster['name']

        provider << node

        hoster[name] = [] unless hoster[name]
        hoster[name] << node
      end

      # figure out which entropy provider to use
      consumer_hoster = nodeinfo['hoster']['name']
      if provider.include?(fqdn) # if the host has an ekeyd
        ans = 'local'
      elsif hoster[consumer_hoster] # if there are any at the same hoster, use one of them
        # if there are more than one ekeys at this hoster pick an arbitrary
        # one, but the same every time
        index = fqdn.hash % hoster[consumer_hoster].length
        ans = hoster[consumer_hoster][index]
      else # pick an arbitrary provider from all providers
        index = fqdn.hash % provider.size
        ans = provider[index]
      end

      return ans
    rescue => e
      raise Puppet::ParseError, "Error in entropy_provider: #{e.message}\n#{e.backtrace}"
    end
  end
end
# vim:set ts=2:
# vim:set et:
# vim:set shiftwidth=2:
