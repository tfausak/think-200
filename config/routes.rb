Think200::Application.routes.draw do
  resources :expectations

  resources :matchers

  resources :requirements

  resources :apps

  resources :projects

  root "pages#home"    
  get "home", to: "pages#home", as: "home"
  get "inside", to: "pages#inside", as: "inside"
  
    
  devise_for :users
  
  namespace :admin do
    root "base#index"
    resources :users
  end

  ResqueWeb::Engine.eager_load!
  mount ResqueWeb::Engine => "/resque"
end
