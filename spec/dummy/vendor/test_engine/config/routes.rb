TestEngine::Engine.routes.draw do
  resources :tests, only: [:index] do
    collection do
      get :recent
    end
  end
end
