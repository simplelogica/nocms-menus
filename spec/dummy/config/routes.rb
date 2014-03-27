Rails.application.routes.draw do

  resources :products

  resources :pages, only: [:index]
  get '*path', to: 'pages#show'

end
