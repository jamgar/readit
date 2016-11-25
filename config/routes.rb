Rails.application.routes.draw do
  get 'users/show'

  root "stories#index"

  resources :stories do
    collection do
      get "bin"
    end
    resources :votes
  end
  resources :users
  resource :session
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
