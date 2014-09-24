#require_dependency "access_control/application_controller"

module AccessControl
  class ApplicationController < ActionController::Base
    include ApplicationControllerExtension
    layout 'home'
    
    before_action :default_variables
    before_filter :store_location, :authenticate_user!, :acl_verifyroute!
    
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
    
    def store_location
      return unless request.get? 
      if (request.path != "/users/sign_in" &&
          request.path != "/users/sign_up" &&
          request.path != "/users/password/new" &&
          request.path != "/users/password/edit" &&
          request.path != "/users/confirmation" &&
          request.path != "/users/sign_out" &&
          !request.xhr?) # don't store ajax calls
        session[:previous_url] = request.fullpath 
      end
    end
    
  end
end
