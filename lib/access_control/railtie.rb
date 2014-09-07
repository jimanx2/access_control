require 'access_control'

module AccessControl
  class Railtie < Rails::Railtie
    initializer "access_control.configure" do |app|
      
      ActiveSupport.on_load :action_view do
        include AccessControl::TemplateHelper
      end
      
      AccessControl.configure do |config|  
        config.superadmin_role = "Administrator"
        config.userclass = :user
        config.roleclass = :role
        config.acl_exit_path = '/'
      end
    end
    
  end
end