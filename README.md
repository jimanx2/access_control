[![Build Status](https://drone.io/github.com/jimanx2/access_control/status.png)](https://drone.io/github.com/jimanx2/access_control/latest)

access_control
==============

Getting Started
===
    - rails new app_name
    - cd app_name
    - add line “gem access_control, :github => ‘jimanx2/access_control’ to Gemfile
    - add line “gem ‘devise’ to Gemfile
    - uncomment gem “therubyracer”, :platform => ‘ruby'
    - bundle install
    - rails g devise:install
    - rails g devise User
    - rails g model Role name:string code:string
    - rails g migration add_role_id_to_users
    - edit the migration file, add this line: add_column :users, :role_id, :integer
    - edit database in config/database.yml (if necessary)
    - rake db:migrate
    - rails console
    - Role.create(:name => “Administrator”, :code => “SA”)
    - User.create(:email => “Your email”, :password => “Your password”, :role_id => Role.find(:code => “SA”).id)
    - then exit CTRL+D 
    - add a route with :as => :access_denied_page into config/route.rb, example: get ‘/access_denied’ => ‘pages#access_denied’, :as => :access_denied_page
    - create a controller to handle #10: rails g controller pages access_denied
    - rails server
    - browse http://localhost:3000
    - navigate to http://localhost:3000/acl-mgr for ACL user interface
