begin
    require 'etc'

    Facter.add("debsso_skac_crl") do
        setcode do
            crl = nil
            crlfile = '/srv/sso.debian.org/debsso/data/spkac_ca/ca.crl'
            if FileTest.exist?(crlfile)
                crl = File.open(crlfile).read
            end
            crl
        end
    end

rescue Exception => e
end
# vim:set et:
# vim:set ts=4:
# vim:set shiftwidth=4:
