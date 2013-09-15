EmbeddableChats::Application.routes.draw do
  root to: 'home#index'
  resources :rooms do
    resources :messages, only: [:create]
    get 'feed', to: 'messages#index'
  end

  get '/dashboard', to: 'home#dashboard', as: :dashboard
  get '/auth/:provider/callback', to: 'sessions#create'
end
