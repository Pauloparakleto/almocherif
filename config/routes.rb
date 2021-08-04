Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :items do
    collection do
      post :entry
      post :exit
    end
  end
end
