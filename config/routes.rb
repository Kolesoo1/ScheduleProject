Rails.application.routes.draw do
  root "pages#home"
  resources :users, only: [:index, :show]
end
