module AccessControl
  class Engine < ::Rails::Engine
    engine_name 'access_control'
    isolate_namespace AccessControl
    
    config.autoload_paths += [ "#{config.root}/lib/" ]
    
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
    
    initializer :append_routes do |app|
      Rails::Application::Configuration.send :include, AccessControl::Engine.routes.url_helpers
    end
  end
  
end
