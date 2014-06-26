LsiRailsPrototype::Application.routes.draw do


  resources :vncrelays

  # create fake root options for WebDAV-MiniRedir, which needs a successful OPTIONS request
  match "/" => "virtual_datasets#options", via: [:options]

  # special webdav handling for WebDAV-MiniRedir (file explorer)
  mount DAV4Rack::Handler.new(

      :root => "/davwwwroot",
      :root_uri_path => '/davwwwroot',
      :resource_class => VirtualDataset

    ), :at => '/', :constraints => {:user_agent => /Microsoft-WebDAV-MiniRedir/}


  # all the other webdav clients
   mount DAV4Rack::Handler.new(

      :root => "/",
      :root_uri_path => '/davwwwroot',
      :resource_class => VirtualDataset

    ), :at => '/davwwwroot/'



  resources :libraries do
    resources :library_entries do
      post 'sort', on: :collection
    end
  end

  resources :reactions do

    get 'zip', on: :member

    get 'createdirect', on: :collection, as: :createdirect

    get 'assign', on: :member
    post 'assign', on: :member, as: :assign_to_project_do, :to => 'reactions#assign_do'
  end

  resources :samples do

    get 'zip', on: :member
    
    get 'assign', on: :member
    post 'assign', on: :member, as: :assign_to_project_do, :to => 'samples#assign_do'

    get 'split', on: :member
    get 'transfer', on: :member

    get 'addliterature', on: :member, as: :add_literature_to, :to => 'samples#addliterature'
  end

  resources :locations

  resources :devices do
    get 'showvnc', on: :member
    get 'connect', on: :member
    post 'connectit', on: :member, as: :connect_do

    get 'assign', on: :member
    post 'assign', on: :member, as: :assign_to_project_do, :to => 'devices#assign_do'

    get 'checkinselect', on: :member, as: :checkinselect_sample_to
    get 'checkin', on: :member, as: :checkin_sample_to
    get 'checkout', on: :member, as: :checkout_sample_to

    get 'startrun', on: :member, as: :startrun_at
    get 'stoprun', on: :member, as: :stoprun_at

    get 'samplelocations', on: :member, as: :samplelocations_at
  end

  resources :folder_watchers do
    get 'assign', on: :member
    post 'assign', on: :member, as: :assign_to_project_do, :to => 'folder_watchers#assign_do'

    get 'export', :on => :collection
  end

  resources :beaglebones do
    get 'assign', on: :member
    post 'assign', on: :member, as: :assign_to_project_do, :to => 'beaglebones#assign_do'
  end

  resources :measurements do
    get 'import', on: :member
    get 'discard', on: :member

    get 'confirm', on: :member

    post 'assign_molecule', on: :member
    post 'assign_reaction', on: :member
    post 'assign_sample', on: :member
  end

  controller :datasets do
    post 'datasets/:id/plot' => :plotpoint
    post 'datasets/plot' => :plotpoint
    post 'datasets/munch' => :munch
  end
  
  resources :datasets do
    get 'zip', on: :member
    get 'fork', on: :member
    post 'commit', on: :member
   #get 'assign', on: :member
   #post 'assign', on: :member, as: :assign_to_project_do, :to => 'datasets#assign_do'
   
    resources :attachments do
      post 'link', :on => :collection
    end
    get 'filter', :on => :collection

    get 'find', :on => :collection
    get 'finalize', :on => :collection
    
    get 'createdirect', :on => :collection, as: :create_direct, :to => "datasets#create_direct"
   

  end

  get 'datasets/:dataset_id/:folder/:filename.:extension', :to => 'attachments#serve'
  get 'datasets/:dataset_id/:folder/:filename', :to => 'attachments#serve'
  get 'datasets/:dataset_id/:filename.:extension', :to => 'attachments#serve'
  get 'datasets/:dataset_id/:filename', :to => 'attachments#serve'


  resources :affiliations do
    get :autocomplete_user_name, :on => :collection
    get :autocomplete_country_name, :on => :collection
    get :autocomplete_organization_name, :on => :collection
    get :autocomplete_department_name, :on => :collection
    get :autocomplete_group_name, :on => :collection
  end

  resources :molecules do
    get 'pick', :on => :collection
    get 'getdetails', :on => :collection
    get 'filter', :on => :collection, :to => 'molecules#index'

    get 'assign', on: :member
    post 'assign', on: :member, as: :assign_to_project_do, :to => 'molecules#assign_do'

    get 'import', :on => :collection
    post 'import', :on => :collection

    get 'addtoreaction', :on => :collection, as: :addtoreaction, :to => 'molecules#addtoreaction'
  end


  resources :projects do
    get 'adduser/:user_id', :to => 'projects#adduser', :on => :member
    get 'adduser', :to => 'projects#adduser', :on => :member
    get 'invite', :to => 'projects#invite', :on => :member

    get 'import' => 'projects#import', :on => :member
    post 'import' => 'projects#importzip', :on => :member
  end


  devise_for :users, :controllers => {:registrations => "users/registrations"}

  get 'about' => 'pages#about'
  get 'webdav' => 'pages#webdav'

  post 'connect/:serialnumber', :to => "beaglebones#heartbeat"
  get 'folderwatcher/:serialnumber', :to => "folder_watchers#heartbeat"

  get 'showcase/:device_type', :to => "devices#showcase"
  get 'showcase', :to => "devices#showcaseindex"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => 'pages#welcome'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
