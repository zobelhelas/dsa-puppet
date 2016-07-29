begin
    require 'json'

    Facter.add("onion_tor_service_hostname") do
        services = {}

        Dir['/var/lib/tor/onion/*/hostname'].each do |p|
            dir = File.dirname(p)
            service = File.basename(dir)
            hostname = IO.read(p).chomp
            services[service] = hostname
        end
        setcode do
            services.to_json
        end
    end

    Facter.add("onion_balance_service_hostname") do
        services = {}

        Dir['/etc/onionbalance/private_keys/*.key'].each do |p|
            service = File.basename(p, '.key')
            begin
                services[service] = IO.popen(['tor-onion-name', p]).read.chomp
            rescue Errno::ENOENT
            end
        end
        setcode do
            services.to_json
        end
    end


rescue Exception => e
end
