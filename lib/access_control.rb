require "access_control/engine"
require "access_control/railtie" if defined?(Rails)

module AccessControl
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :superadmin_role, :userclass, :roleclass, :acl_exit_path

    def initialize
      @superadmin_role = 'Superadmin'
      @userclass = :user
      @roleclass = :role
      @acl_exit_path = '/'
    end
  end
  
  module PermissionHelper
  
    protected
    def get_named_route(url)
      begin 
        route_path = access_control.routes.recognize_path(url)
      rescue
        route_path = Rails.application.routes.recognize_path(url)
      end
      route_path = "#{route_path[:controller]}##{route_path[:action]}"
    end
    
    protected
    def permitted?(path, user)
      if user.send(AccessControl.configuration.roleclass.to_s).name == AccessControl.configuration.superadmin_role
        return true 
      end
      # check for module permission first
      route_path = path.match(/\@.+/).nil? ? get_named_route(path) : path
      
      modules_related_to_path = AccessControl::Module.select('route_name').joins(
        "JOIN access_control_module_routes acmr ON (access_control_modules.id = acmr.module_id)"
      ).where('acmr.route_path = ?', route_path)
      
      unless modules_related_to_path.empty?
        route_path = modules_related_to_path.pluck(:route_name).map{|a| "!#{a}"} << route_path
      end
      
      permit = Permission.where(:route_path => route_path)
      
      return false if permit.empty?
      # find for permission for user first
      userpermit = permit.where('requester_type = ? AND requester_id = ?', 'User', user.id)
      rolepermit = permit.where(
        'requester_type = ? AND requester_id = ?', 'Role', user.send(AccessControl.configuration.roleclass.to_s).id
      )
      
      unless userpermit.empty?
        return userpermit.pluck(:allow).inject(:|)
      end      
      
      return rolepermit.pluck(:allow).inject(:|)
    end
  end
  
  module TemplateHelper
    include AccessControl::PermissionHelper  
    
    def menuitem_for(href, &block)
      @url = href
      yield if permitted?(href, eval("current_#{AccessControl.configuration.userclass.to_s}") )
    end
    
    def element_for (href, &block)
      @ret = href
      yield if permitted?(href, eval("current_#{AccessControl.configuration.userclass.to_s}") )
    end
  end
  
  module ApplicationControllerExtension
    include AccessControl::PermissionHelper
    def self.included(base)
      base.instance_eval do 
        before_filter :acl_verifyroute!
      end
      
      def acl_verifyroute!
        unless permitted?(request.env['PATH_INFO'], eval("current_#{AccessControl.configuration.userclass.to_s}") )
          flash[:warning] = "You are not authorized to access that page <!--#{params[:controller]}##{params[:action]}-->"
          if request.format == 'html'
            redirect_to Rails.application.routes.url_helpers.access_denied_page_path 
          else
            render json: flash[:warning], :status => 422
            return
          end
        end
      end
    end

  end
end
