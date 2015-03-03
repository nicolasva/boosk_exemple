BoosketShop::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/__workers'

  resources :trackers,         :only => :create

  constraints(:subdomain => 'shops') do
    devise_for :users,  :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret',
                        :confirmation => 'verification', :unlock => 'unblock', :registration => 'register',
                        :sign_up => 'signup'},
                        :controllers => {
                          :omniauth_callbacks => 'users/omniauth_callbacks',
                          :registrations      => 'users/registrations'
                        }

    resources :administrators, :only => [:index, :create] do
      delete 'destroy/all' => 'administrators#destroy_all', :on => :collection
    end

    resource :subscription, :except => [:destroy, :show, :index] do
      get '/', :to => :new
    end

    resources :plans, :only => [:index, :create] do
      post 'ipn_notification',   :on => :collection
      get  'paypal_success_url', :on => :collection
    end

    resources :wizards, :path => "wizard", :only => [:index, :create] do
      get 'devises', :on => :collection
    end

    resource :dashboard, :only => [:show, :update] do
      get 'translate',           :on => :member
      get 'geographic_regions',  :on => :member
      get 'general_analytics',   :on => :member
      get 'shop_functionnality', :on => :member
    end

    resources :shops do
      resources :analytics,    :only => [:index]
      resource :customization, :only => [:show, :edit, :update]

      resources :products do
        delete 'destroy/all' => 'products#destroy_all', :on => :collection
        get 'import', :on => :collection
        post 'import_by_upload', :on => :collection
        post 'copy', :on => :collection
        resources :product_variants, :except => [:show]
      end
      resources :option_types do
        delete 'destroy/all' => 'option_types#destroy_all', :on => :collection
      end
      resources :orders, :only => [:index, :show, :update], :constraints => {:id => /[a-f|0-9|-]*/} do 
        put 'update/all' => 'orders#update_all', :on => :collection
      end
      resources :zones do 
        delete 'destroy/all' => 'zones#destroy_all', :on => :collection
      end
      resources :tax_rates do
        delete 'destroy/all' => 'tax_rates#destroy_all', :on => :collection
      end
      resources :shipping_methods do
        delete 'destroy/all' => 'shipping_methods#destroy_all', :on => :collection
      end
      resources :shipping_categories
      resources :taxonomies do
        resources :taxons
      end
      resources :promotions do
        delete 'destroy/all' => 'promotions#destroy_all', :on => :collection
      end
    end

    resources :calculator_types, :only => [:index]
    resources :attachments,      :only => :create
    resource :account,           :only => [:show, :update, :destroy]

    root :to => 'dashboards#show'
  end

  namespace :frontoffice, :path => "/", :constraints => { :subdomain => /.+/ } do
    match "translate" => "shops#translate"
    match "geographic_regions" => "shops#geographic_regions"
    #TODO : this route seems to be useless, as not used anymore
    match "products/:uuid" => "products#show"

    scope "(:ui)", :ui => /facebook|mobile/ do
      #TODO : this route seems to be redundant, check with Guillaume for facebook front
      scope do
        match "new_order" => "orders#create", :via => "POST"
      end
      resources :orders, :only => [:create, :show], :constraints => {:id => /[a-f|0-9|-]+/} do 
        get  "payment_successfully", :on => :collection
        get  "payment_canceled", :on => :collection
        post "ipn_notification", :on => :collection
      end
      resources :shops, :only => [:show], :constraints => {:id => /[a-f|0-9|-]+/} do
        #TODO : refactoring needed
        scope do
          match "add_to_cart" => "cart_items#create", :via => "POST"
          match "update_to_cart" => "cart_items#update", :via => "POST"
          match "delete_to_cart/:id" => "cart_items#destroy", :via => "DELETE"
          match "show_cart" => "cart_items#show", :via => "GET"
        end
        match "pagination_firsts/:paginationfirst_id/pagination_lasts/:id" => "pagination_lasts#show", :via => "GET"
        resources :taxonomies, :only => [:index, :show] do
          resources :taxons, :only => [:index, :show] do
            resources :taxonproducts, :only => [:index]
          end
        end
        resources :products, :only => [:show] do
          get "/", :action => :index, :on => :collection
          resources :product_variants, :only => [:show]  do
            resources :product_variant_pictures, :only => [:index, :show]
          end
          resources :open_graphs, :only => [:create]
        end

        resources :option_types, :only => [:index, :show]

        #TODO : refactoring needed
        scope do
          match "clean_carts" => "carts#destroy", :via => "DELETE"
          match "show_carts" => "carts#show", :via => "GET"
        end
        resources :carts, :only => [:index]
        match "terms_of_services" => "shops#terms_of_services", :via => "GET"
      end

      root :to => "shops#show"
    end
  end

  #temp! 
  namespace :dash, :path => "/___dash" do
    resources :shops, :only => [:index]
    resources :accounts, :only => [:index]
    resources :products, :only => [:index]
    resources :orders, :only => [:index]
  end

end
