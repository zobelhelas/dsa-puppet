module Puppet::Parser::Functions
  newfunction(:has_static_component, :type => :rvalue) do |args|
      static_component = args[0]
      fqdn = lookupvar('fqdn')

      cfg = YAML.load(File.open('/etc/puppet/modules/roles/misc/static-components.yaml').read)

      if cfg.include?('mirrors')
        if cfg['mirrors'].include?(fqdn)
          if cfg['mirrors'][fqdn].include?('components-include')
            if cfg['mirrors'][fqdn]['components-include'].include?(static_component)
              return true
            else
              return false
            end
          end
        end
      end

      if cfg.include?('components')
        if cfg['components'].include?(static_component)
          if cfg['components'][static_component].include?('limit-mirrors')
            return (cfg['components'][static_component]['limit-mirrors'].include?(fqdn))
          elsif cfg['components'][static_component].include?('exclude-mirrors')
            return (not cfg['components'][static_component]['exclude-mirrors'].include?(fqdn))
          else
            return true
          end
        end
      end

      err "Static component #{static_component} appears to be not defined"
      return false
  end
end
