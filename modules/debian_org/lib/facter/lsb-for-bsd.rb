{  "LSBRelease"         => %r{^LSB Version:\t(.*)$},
   "LSBDistId"          => %r{^Distributor ID:\t(.*)$},
   "LSBDistRelease"     => %r{^Release:\t(.*)$},
   "LSBDistDescription" => %r{^Description:\t(.*)$},
   "LSBDistCodeName"    => %r{^Codename:\t(.*)$}
}.each do |fact, pattern|
    Facter.add(fact) do
        confine :kernel => 'GNU/kFreeBSD'
        setcode do
            unless defined?(lsbdata) and defined?(lsbtime) and (Time.now.to_i - lsbtime.to_i < 5)
                type = nil
                lsbtime = Time.now
                lsbdata = Facter::Util::Resolution.exec('lsb_release -a 2>/dev/null')
            end

            if pattern.match(lsbdata)
                $1
            else
                nil
            end
        end
    end
end

