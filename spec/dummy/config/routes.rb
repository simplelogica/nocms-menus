Rails.application.routes.draw do

  resources :products

  mount TestEngine::Engine => "/test"

  resources :pages, only: [:index]
  get '*path', to: 'pages#show'



end
