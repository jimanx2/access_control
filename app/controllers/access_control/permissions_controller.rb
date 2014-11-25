#require_dependency "access_control/application_controller"

module AccessControl
  class PermissionsController < AccessControl::ApplicationController
    #access_control_component
    
    def index
    end
    
    def create
      if params[:route_path].nil?
        redirect_to request.referer 
        return
      end
      
      if params[:requester_type].nil?
        redirect_to request.referer 
        return
      end
      
      params[:route_path].each do |rp|
        allow = to_bool(params[:allow].to_s)
        params[:requester_type].each do |requester|
          req = requester.split('|')
          permission = Permission.new(:requester_type => req[1], :requester_id => req[0], :route_path => rp, :allow => allow)
          permission.save
        end
      end
      redirect_to request.referer 
    end
    # POST chmod
    def show
    end
    
    def update
      permission = Permission.find(params[:id])
      raise ActiveRecord::RecordNotFound if permission.nil?
      permission.allow = !permission.allow?
      if permission.save!
        render text: permission.allow? ? "ALLOWED" : "DENIED"
      else
        render text: "ERROR"
      end
    end
    
    def destroy
      permission = Permission.find(params[:id])
      raise ActiveRecord::RecordNotFound if permission.nil?
      redirect_to permissions_path if permission.destroy
    end
    
    private
    def to_bool str
      return true if str =~ (/^(true|t|yes|y|1)$/i)
      return false if str.empty? || str =~ (/^(false|f|no|n|0)$/i)

      raise ArgumentError.new "invalid value: #{str}"
    end
  end
end
