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
    attr_accessor :superadmin_role, :userclass, :roleclass, :acl_exit_path, :user_display_field

    def initialize
      @superadmin_role = 'Superadmin'
      @userclass = :user
      @roleclass = :role
      @user_display_field = :email
      @acl_exit_path = '/'
    end
  end
  
  module PermissionHelper
    
    protected
    def get_named_route(url)
      route_path = []
      [:get, :post, :delete, :put, :patch].each do |method|
        begin
          route_path = Rails.application.routes.recognize_path(url, :method => method) rescue AccessControl::Engine.routes.recognize_path(url, :method => method)
        rescue
          next
        end
      end
      
      route_path = "#{route_path[:controller]}##{route_path[:action]}"
    end
    
    protected
    def permitted?(path, user)
      if get_user_role(user).name == AccessControl.configuration.superadmin_role
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
        'requester_type = ? AND requester_id = ?', 'Role', get_user_role(user).id
      )
      
      unless userpermit.empty?
        return userpermit.pluck(:allow).inject(:|)
      end      
      
      return rolepermit.pluck(:allow).inject(:|)
    end
    
    protected
    def get_current_user
      begin
        user = eval("current_#{AccessControl.configuration.userclass.to_s}")
      rescue NameError
        raise "Cannot access current_#{AccessControl.configuration.userclass.to_s}. Perhaps you have missed one of the following:\n\n" <<
              "1. Ensuring config.userclass points to correct model. You can do this in an initializer like follows:\n\n"<<
              "AccessControl.configuration.do |config|\n" <<
              "\tconfig.userclass = :your_user_class\n" <<
              "end\n\n" <<
              "2. Defining the model for Devise itself. You can do like the following in your terminal: \n\n" <<
              "your/rails/app #> rails g devise YourDeviseModel (e.g User) \n" <<
              "your/rails/app #> rake db:migrate\n"
      end
    end
    
    protected
    def get_user_role(user)
      #begin
      user.send(AccessControl.configuration.roleclass)
      #rescue NoMethodError
      #  raise "Cannot access #{AccessControl.configuration.roleclass.to_s} attribute of model " <<    
      #        "#{AccessControl.configuration.userclass.to_s.camelize}. Did you: \n\n" <<
      #        "1. Forget to define required relationship?\n" <<
      #        "2. Default config.roleclass is set to :role so you might have to change it in related initializer:\n\n"<<
      #        "AccessControl.configuration.do |config|\n" <<
      #        "\tconfig.roleclass = :your_role_class\n" <<
      #        "end\n\n"
      #end
    end
  end
  
  module TemplateHelper
    include AccessControl::PermissionHelper  
    
    def menuitem_for(href, &block)
      @url = href
      yield if permitted?(href, get_current_user )
    end
    
    def element_for (href, &block)
      @ret = href
      yield if permitted?(href, get_current_user )
    end
  end
  
  module ApplicationControllerExtension
    include AccessControl::PermissionHelper
    
    def acl_verifyroute!
      ActiveSupport.run_load_hooks :acl_extension, self
      current_user = get_current_user
      unless permitted?(request.env['PATH_INFO'],  current_user )
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
