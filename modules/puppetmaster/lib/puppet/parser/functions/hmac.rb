module Puppet::Parser::Functions
  newfunction(:hmac, :type => :rvalue) do |args|
    secretfile = args.shift()
    data = args.shift()

    require 'openssl'
    secret = ""
    begin
      secret = File.new(secretfile, "r").read
    rescue => e
      raise Puppet::ParseError, "Error loading secret from #{secretfile}: #{e.message}\n#{e.backtrace}"
    end

    return OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), secret, data)
  end
end
# vim:set ts=2:
# vim:set et:
# vim:set shiftwidth=2:
