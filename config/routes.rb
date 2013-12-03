Forecasts::Application.routes.draw do
  devise_for :users

  resources :forecasts
  
  get 'search' => 'forecasts#search'
  
  root :to => "forecasts#index"

end
