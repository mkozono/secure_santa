SecureSanta::Application.routes.draw do

  root :to => 'events#new'

  get 'e/:admin_uid', to: 'events#show_admin', as: 'event_admin'
  get 'e/:admin_uid/edit', to: 'events#edit', as: 'edit_event'
  patch 'e/:admin_uid', to: 'events#update'
  delete 'e/:admin_uid', to: 'events#destroy'
  patch 'e/:admin_uid/assign_giftees', to: 'events#assign_giftees', as: 'assign_giftees_event'
  patch 'e/:admin_uid/u/:uid/reset_user', to: 'users#reset_user', as: 'reset_user'

  get 'u/:uid', to: 'users#show_verified', as: 'verified_user'
  patch 'events/:event_id/users/:id/confirm', to: 'users#confirm', as: 'confirm_event_user'

  resources :events, :only => [:index, :show, :new, :create] do
    resources :users, :only => [:show, :show_verified]
  end

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
