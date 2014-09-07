class AppModel < ActiveRecord::Base
  establish_connection :adapter => 'sqlite3', :database => 'db/your_engine.sqlite3'
  
  
end