Rails.application.routes.draw do
  scope path: "/places" do
    resources :favorites
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
