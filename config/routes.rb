SecureSanta::Application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  devise_scope :user do
    # Create our own sign out route pointing to devise's controller.
    delete '/users/sign_out' => 'devise/sessions#destroy'
  end

  root :to => 'events#new'

  get 'e/:admin_uid', to: 'events#show_admin', as: 'event_admin'
  get 'e/:admin_uid/edit', to: 'events#edit', as: 'edit_event'
  patch 'e/:admin_uid', to: 'events#update'
  delete 'e/:admin_uid', to: 'events#destroy'
  patch 'e/:admin_uid/assign_giftees', to: 'events#assign_giftees', as: 'assign_giftees_event'

  patch 'e/:admin_uid/p/:uid/reset_player', to: 'players#reset_player', as: 'reset_player'
  patch 'events/:event_id/players/:id/confirm', to: 'players#confirm', as: 'confirm_event_player'
  get 'p/:uid', to: 'players#show_verified', as: 'verified_player'
  patch 'p/:uid', to: 'players#update_verified'

  resources :events, :only => [:index, :show, :new, :create] do
    resources :players, :only => [:show, :show_verified]
  end

  get 'user', to: 'users#events', as: 'user'
  get 'user/events', to: 'users#events', as: 'user_events'

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
