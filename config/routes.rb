Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root 'units/calculations#new'
  
  get '/electricity', to: 'units/calculations#new'
  get '/inverter', to: 'inverters/calculations#new'
  
  post '/calc_electricity', to: 'units/calculations#calculate'
  post '/calc_inverter', to: 'inverters/calculations#calculate'
end
