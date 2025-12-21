Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'sessions'
  }

  root to: 'home#index'

  get 'dashboard', to: 'dashboard#index'

  resource :student_profile, only: [:show, :edit, :update, :new, :create]
  resource :teacher_profile, only: [:show, :edit, :update, :new, :create]

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
  end

  get 'about', to: 'home#about'
  get 'contact', to: 'home#contact'
end