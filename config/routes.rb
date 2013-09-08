EmbeddableChats::Application.routes.draw do
  root to: 'home#index'
  resources :rooms do
    resources :messages, only: [:create]
  end

  get '/dashboard', to: 'home#dashboard', as: :dashboard
  get '/auth/:provider/callback', to: 'sessions#create'
end
