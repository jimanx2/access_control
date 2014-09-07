#require_dependency "access_control/application_controller"

module AccessControl
  class ModulesController < AccessControl::ApplicationController
    #access_control_component
    
    def create
      if params[:module_name].nil?
        redirect_to request.referer 
        return
      end
      
      AccessControl::Module.create(:name => params[:module_name], :route_name => params[:module_name].underscore.downcase)
      redirect_to request.referer
    end
    
    def edit
      @mod = AccessControl::Module.find(params[:id])
      @routes = @routes.select{|x| x[0] != '!'}
    end
  end
end
