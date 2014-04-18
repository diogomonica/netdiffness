Netdiffness::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  resources :scans, only: [:index, :show, :create, :new, :update]

  match 'scans/:id/rescan', to: 'scans#rescan', as: :rescan, via: [ :post ]
  match 'scan_results/:id/compare/:cid', to: 'scan_results#compare', as: :compare, via: [ :get ]
end
