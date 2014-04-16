Netdiffness::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  resources :scans, only: [:index, :show, :create, :new ]

  match 'scans/:id/rescan', to: 'scans#rescan', as: :rescan, via: [ :post ]
end
