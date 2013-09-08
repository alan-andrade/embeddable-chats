EmbeddableChats::Application.routes.draw do
  root to: 'home#index'
  resources :rooms
  get '/dashboard', to: 'home#dashboard', as: :dashboard
  get '/auth/:provider/callback', to: 'sessions#create'
end
