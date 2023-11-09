Rails.application.routes.draw do
  devise_for :users
  #root 'todo#homepage'
  get '/categoria', to: 'todo#categoria'
  #resources :todo
  get '/descripcion', to: 'todo#descripcion'
  root 'todo#index'
  get '/resultado', to: 'todo#resultado'
  get '/homepage', to: 'todo#homepage'
  post 'todo/enlistar', to: 'todo#enlistar', as: 'enlistar_pelicula'
  get '/lista', to: 'todo#lista'
  delete 'eliminar_pelicula_lista/:id', to: 'todo#eliminar_pelicula_lista', as: 'eliminar_pelicula_lista'
  #root 'todo#homepage'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
