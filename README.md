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
    - edit database in config/database.yml (if necessary)
    - rails g access_control [USER_MODEL_NAME] [ROLE_MODEL_NAME], eg: rails g access_control User Role
    - create a controller to handle route from previous page: rails g controller pages access_denied
    - rails server
    - browse http://localhost:3000
    - navigate to http://localhost:3000/acl-mgr for ACL user interface
