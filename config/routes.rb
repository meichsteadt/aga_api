Rails.application.routes.draw do
  get 'users/:login/:password', to: "users#show"
  resources :users
  resources :emails
  resources :product_items, :dining, :seating, :bedroom, :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
