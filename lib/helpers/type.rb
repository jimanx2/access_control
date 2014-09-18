module AccessControl::Helpers
  module TypeHelper
    class << self
    end
    
    def class_exists?(class_name)
      klass = Module.const_get(class_name)
      return klass.is_a?(Class)
    rescue NameError
      return false
    end
  end
end