module AccessControl::Helpers
  module GeneratorHelper
    class << self
    
    end
    
    def route(routing_code)
      #log :route, routing_code
      sentinel = /\.routes\.draw do\s*$/
    
      inject_into_file File.expand_path('.')+'config/routes.rb', "\n  #{routing_code}", { after: sentinel, verbose: false }
    end
    
    def generate(what, *args)
      #log :generate, what
      argument = args.map {|arg| arg.to_s }.flatten.join(" ")
    
      run_ruby_script("bin/rails generate #{what} #{argument}", verbose: false)
    end
  end
end