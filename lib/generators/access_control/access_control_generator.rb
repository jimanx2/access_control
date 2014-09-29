require 'helpers/type'

class AccessControlGenerator < Rails::Generators::NamedBase
  include AccessControl::Helpers::TypeHelper
  source_root File.expand_path('../templates', __FILE__)
  
  argument :role_model, :type => :string, :default => "Role"
  
  def generate_install
    # first check if User model exist.
    unless class_exists?(role_model.titlecase)
      generate "model #{role_model.titlecase} name:string code:string"
    end
    unless class_exists?(class_name)
      # model not exist. use our devise to generate it
      generate "devise:install"
      generate "devise #{class_name}"
    end
    
    inject_into_file "app/models/#{file_name}.rb", :before => "end" do
      "belongs_to :#{role_model.downcase}\n
       def name
        \"edit me in app/models/#{class_name.downcase}.rb\"
       end
      "
    end
    
    generate "migration add_#{role_model.downcase}_id_to_#{file_name} role_id:integer"
    
    create_file "config/initializers/access_control.rb", <<-FILE
      AccessControl.configure do |config|  
        config.superadmin_role = "Administrator"
        config.userclass = :#{file_name}
        config.roleclass = :#{role_model.downcase}
        config.acl_exit_path = '/'
      end
    FILE
    
    append_file "db/seeds.rb", <<-FILE
      #{role_model.titlecase}.create(:name => "Administrator", :code => "SA")
      #{class_name}.create(:email => "admin@yoursite.com", :password => "password", :#{role_model.downcase}_id => #{role_model.titlecase}.find_by(:name => "Administrator").id)      
    FILE
    
    append_file "app/models/"
    
    route "get '/access-denied' => 'pages#access_denied', :as => :access_denied_page"
  end
  
end
