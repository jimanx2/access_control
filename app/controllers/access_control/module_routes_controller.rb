#require_dependency "access_control/application_controller"

module AccessControl
  class ModuleRoutesController < AccessControl::ApplicationController
    #access_control_component
    
    def create
      if params[:route_path].nil? && params[:element_name].nil?
        redirect_to request.referer 
        return
      end
      
      params[:route_path].each do |rp|
        ModuleRoute.create(:module_id => params[:module_id], :route_path => rp)  
      end
      
      params[:element_name].split(';').each do |en|
        ModuleRoute.create(:module_id => params[:module_id], :route_path => en)  
      end
      
      redirect_to request.referer
    end
    
    def destroy
      if params[:id].nil?
        redirect_to request.referer 
        return
      end
      
      ModuleRoute.find(params[:id]).destroy
      redirect_to request.referer
    end
  end
end
