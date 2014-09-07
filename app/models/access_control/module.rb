module AccessControl
  class Module < ActiveRecord::Base
    has_many :module_routes
  end
end
