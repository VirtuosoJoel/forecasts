Forecasts::Application.routes.draw do
  devise_for :users

  resources :forecasts
  
  root :to => "forecasts#index"

end
