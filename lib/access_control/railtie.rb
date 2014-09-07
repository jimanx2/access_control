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
        config.user_display_field = :email
      end
      
      config.after_initialize do 
        eval(AccessControl.configuration.userclass.to_s.camelize).class_eval do 
          def name
            eval(AccessControl.configuration.user_display_field.to_s)
          end
        end
      end
      
    end
    
  end
end