Rails.application.routes.draw do
  # get 'users/:login/:password', to: "users#show"

  post "get_prices_to_update", to: 'update_prices#index'
  post "update_prices", to: 'update_prices#update'
  post "missing_items", to: 'missing_items#index'
  resources :users do
    resources :dining, :seating, :bedroom, :products, :youth, :occasional, :home, :new_arrivals, :show_sku
  end
  resources :emails
  resources :dining, :seating, :bedroom, :products, :youth, :occasional, :home, :searches, :categories
  get 'sub_categories/:category', to: 'sub_categories#show'
  resources :sub_categories
  resources :images

  resources :product_items do
    resources :prices
  end

  scope :format => true, :constraints => { :format => 'json' } do
    post   "/login"       => "sessions#create"
    delete "/logout"      => "sessions#destroy"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
