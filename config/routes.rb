Rails.application.routes.draw do
  # 注文入力・注文作成
resources :orders, only: [:index, :new, :create] do 
  collection do
    post :confirm   # 注文確認
  end
  member do
    get :complete  # 注文完了
  end
end
  get "mypage/show"
  devise_for :users
  resources :mypage, only: [:show] # ユーザ情報の詳細表示
  # 商品関連
  resources :products
  
  # get "products/new"
  # post 'products', to: 'products#create'  # 登録
  # get 'products', to: 'products#index'
  root to: "homes#top"
  # get 'products/:id', to: 'products#show', as: 'product'
  # get 'products/:id/edit', to: 'products#edit', as: 'edit_product'
  # patch 'products/:id', to: 'products#update' # 編集
  # delete 'products/:id', to: 'products#destroy', as: 'destroy_product'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
