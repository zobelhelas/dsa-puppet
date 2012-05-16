if FileTest.exist?('/usr/sbin/gnt-cluster')
  if system('/usr/sbin/gnt-cluster getmaster >/dev/null')
    require 'json'
    config = '/var/lib/ganeti/config.data'
    Facter.add('cluster') do
      setcode do
        JSON.parse(File.read(config))['cluster']['cluster_name']
      end
    end
  end
end
