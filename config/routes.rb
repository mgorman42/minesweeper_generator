Rails.application.routes.draw do
  root "boards#new"
  resources :boards do
    get :tiles, to: "boards/tiles#index"
  end
end
