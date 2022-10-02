Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'users/signup'
      get 'users/show'
      get 'users/update'
      get 'users/close'
      resources :recepies
    end
  end
end