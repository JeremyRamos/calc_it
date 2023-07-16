Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'calculations#new'

  resources :calculations, only: [:new, :create] do
    post :calculate, on: :collection
  end
  
  get '/units_calculation', to: 'units/calculations#new'
  post '/units_calculation', to: 'units/calculations#calculate'
end
