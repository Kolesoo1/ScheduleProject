Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'registrations',
    sessions: 'sessions'
  }

  root to: 'home#index'

  get 'dashboard', to: 'dashboard#index'

  resource :student_profile, only: [:show, :edit, :update, :new, :create]
  resource :teacher_profile, only: [:show, :edit, :update, :new, :create]

  resources :courses

  get 'admin/dashboard', to: 'dashboard#admin_dashboard', as: :admin_dashboard
  get 'admin/users', to: 'dashboard#admin_users', as: :admin_users
  get 'admin/subjects', to: 'dashboard#admin_subjects', as: :admin_subjects
  get 'admin/classrooms', to: 'dashboard#admin_classrooms', as: :admin_classrooms

  get 'about', to: 'home#about'
  get 'contact', to: 'home#contact'
end