require 'puppet/file_system'

module Puppet::Parser::Functions
  newfunction(:yamlinfo, :type => :rvalue) do |args|

    host = args[0]

    read_yaml = lambda { |yaml, host|
      results = {}

      ['nameinfo', 'footer'].each do |detail|
        if yaml.has_key?(detail)
          if yaml[detail].has_key?(host)
            results[detail] = yaml[detail][host]
          end
        end
      end
      
      if yaml.has_key?('services')
        yaml['services'].each_pair do |service, hostlist|
          hostlist=[hostlist] unless hostlist.kind_of?(Array)
          results[service] = hostlist.include?(host)
        end
      end

      results['mail_port']      = ''
      results['smarthost']      = ''
      results['heavy_exim']     = ''
      results['smarthost_port'] = 587

      if yaml['host_settings'].kind_of?(Hash)
        yaml['host_settings'].each_pair do |property, values|
          if values.kind_of?(Hash)
            results[property] = values[host] if values.has_key?(host)
          elsif values.kind_of?(Array)
            results[property] = values.include?(host)
          end
        end
      end
      return(results)
    }

    require 'yaml'

    yamlfile = Puppet::Parser::Files.find_file('debian_org/misc/local.yaml', compiler.environment)
    yaml = YAML.load_file(yamlfile)
    ret = {}

    if host == '*'
      Dir.entries('/var/lib/puppet/yaml/node/').each do |fname|
        next unless fname =~ /(.*)\.yaml$/
        host_name = $1
        ret[host_name] = read_yaml.call(yaml, host_name)
      end
    else
      ret = read_yaml.call(yaml, host)
    end

    return(ret)
  end
end

