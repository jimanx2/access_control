require 'access_control'

module AccessControl
  class Railtie < Rails::Railtie
    initializer "access_control.configure" do |app|
      
      ActiveSupport.on_load :action_view do
        include AccessControl::TemplateHelper
      end
    end
  end
end