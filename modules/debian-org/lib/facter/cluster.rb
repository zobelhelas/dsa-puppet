Facter.add('cluster') do
  setcode do
    if FileTest.exist?('/usr/sbin/gnt-cluster')
      if system('/usr/sbin/gnt-cluster getmaster >/dev/null')
        require 'json'
        config = '/var/lib/ganeti/config.data'
        if FileTest.exist?(config)
          JSON.parse(File.read(config))['cluster']['cluster_name']
        else
          ''
        end
      end
    else
      ''
    end
  end
end
