Facter.add('cluster') do
  setcode do
    if system('/usr/sbin/gnt-cluster getmaster')
      require 'json'
      config = '/var/lib/ganeti/config.data'
      if FileTest.exist?(config)
        JSON.parse(File.read(config))['cluster']['cluster_name']
      else
        ''
      end
    end
  end
end
