AccessControl::Engine.routes.draw do
  resources :permissions, :modules, :module_routes
  
  controller :permissions do
    get "/acl-mgr/permissions" => "permissions#index"
    get "/acl-mgr/permissions/new" => "permissions#new"
  end
  
  controller :modules do
    get "/acl-mgr/modules" => "modules#index"
    get "/acl-mgr/modules/new" => "modules#new"
  end
  
  controller :home do
    get '/acl-mgr' => 'home#index'  
  end
  root :to => 'home#index'
end

Rails.application.routes.draw do
  mount AccessControl::Engine => "/acl-mgr", as: 'access_control'
end