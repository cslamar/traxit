Traxit::Application.routes.draw do

  get 'items/new' => 'items#new'
  get 'items/propitem/:property' => 'items#propitem'
  post 'items/create' => 'items#create'

  patch 'items/complete' => 'items#complete'
  patch 'items/reset' => 'items#reset'
  
  get 'items/service_add/:id' => 'items#service_add', :as => :service_add
  post 'items/service_create/:id' => 'items#service_create'

  get 'items/overview/:id' => 'items#overview', :as => :item_overview
  post 'items/update_manual' => 'items#update_manual'
  post 'items/assign_handler' => 'items#assign_handler'
  delete 'items/info/:id' => 'items#destroy'

  get 'items/new_field/:unique' => 'items#new_field'
  get 'items/properties/:id' => 'items#properties', :as => :properties
  post 'items/update_properties/:id' => 'items#update_properties'

  get 'items/image/:id' => 'items#image', :as => :item_image
  get 'items/big_image/:id/:num' => 'items#big_image', :as => :big_image
  get 'items/remove_image/:id/:num' => 'items#remove_image', :as => :remove_image
  post 'items/update_image' => 'items#update_image'

  get 'items/qr/:id' => 'items#qr', :as => :qr_code
  get 'items/info/:id' => 'items#info'
  get 'items/notes/:wid/:sid' => 'items#notes', :as => :notes
  get 'items' => 'items#list'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
