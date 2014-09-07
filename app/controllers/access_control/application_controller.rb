#require_dependency "access_control/application_controller"

module AccessControl
  class ApplicationController < ActionController::Base
    include ApplicationControllerExtension
    layout 'home'
    
    before_action :authenticate!
    before_action :default_variables
    
    def default_variables
      @pathname = request.env['PATH_INFO']
      @permissions = Permission.order(:route_path, :requester_type)
      @routes = 
        Rails.application.routes.routes.collect(&:defaults).map {|a| "#{a[:controller]}##{a[:action]}"} + 
        AccessControl::Module::all.map do |a| "!#{a.route_name}" end
      @modules = AccessControl::Module.all
      @requester = Role.all + User.all
      @elements = 
        Permission.where("route_path LIKE '@%'") + 
        ModuleRoute.where("route_path LIKE '@%'")
      @elements = @elements.collect(&:route_path)
      @menus = []
    end
  end
end
