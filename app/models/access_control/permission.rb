module AccessControl
  class Permission < ActiveRecord::Base
    
    def requester
      eval(requester_type).find(requester_id)
    end
    
  end
end
