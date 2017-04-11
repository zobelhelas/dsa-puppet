module OctocatalogDiff
  class Config
    def self.config
      settings = {}
      settings[:hiera_config] = 'spec/octocatalog/hiera.yaml'
      settings[:hiera_path] = 'hieradata'
      settings[:storeconfigs] = false
      settings[:validate_references] = %w(before notify require subscribe)
      settings
    end
  end
end
