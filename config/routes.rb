Rails.application.routes.draw do
  resources :emails
  resources :product_items, :dining, :seating, :bedroom, :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
