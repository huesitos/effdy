Rails.application.routes.draw do
  root 'review#study_calendar'

  get 'share_request/new/:object_type/:oid/:name' => 'share_request#new', as: :share_request_new
  post 'share_requests/:object_type/:oid/:name' => 'share_request#create', as: :share_requests
  get 'share_request/share/:id' => 'share_request#share', as: :share_request_share
  get 'share_request/notify' => 'share_request#notify', as: :share_request_notify
  delete 'share_request/destroy/:id' => 'share_request#destroy', as: :share_request_destroy
  delete 'share_request/:object_type/:oid/remove_collaborator/:user_id' => 'share_request#remove_collaborator', as: :share_request_remove_collaborator

  get 'study_calendar' => 'review#study_calendar'

  resources :subjects do
    patch 'archive' => 'subjects#archive', as: :archive
  end

  resources :topics do
    resources :cards, except: [:index]
    get 'review/' => 'review#review', as: :review
    get 'review/card/:card_id/front/' => 'review#front', as: :card_front
    get 'review/card/:card_id/back/' => 'review#back', as: :card_back
    post 'review/card/:card_id/answer' => 'review#answer', as: :card_answer
    patch 'reset_cards' => 'topics#reset_cards', as: :reset_cards
    patch 'set_reviewing' => 'topics#set_reviewing', as: :set_reviewing
  end

  get 'login' => 'welcome#welcome', as: 'login'
  get '/auth/:provider', to: lambda{|env| [404, {}, ["Not Found"]]}, as: 'login_provider'
  get '/auth/:provider/callback', to: 'session#create'
  get '/logout', to: 'session#destroy', as: 'logout'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
