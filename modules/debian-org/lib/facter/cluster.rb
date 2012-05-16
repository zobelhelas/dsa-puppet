if FileTest.exist?('/usr/sbin/gnt-cluster')
  if system('/usr/sbin/gnt-cluster getmaster >/dev/null')
    require 'json'
    json = JSON.parse(File.read('/var/lib/ganeti/config.data'))
    Facter.add('cluster') do
      setcode do
        json['cluster']['cluster_name']
      end
    end
    Facter.add('cluster_nodes') do
      setcode do
        json['nodes'].keys.join(' ')
      end
    end
  end
end
