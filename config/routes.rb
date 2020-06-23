Rails.application.routes.draw do
  scope path: ENV["PATHNAME_PREFIX"] do
    resources :favorites
    resources :apartments
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
