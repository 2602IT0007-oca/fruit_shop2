Rails.application.routes.draw do
  # --- 変更前 ---
  # get "carts/show"
  # get "carts/index"
  
  # --- 変更後 ---
  resources :carts, only: [:show, :index] do
    collection do
      post :add_product  # カートに商品を追加
    end
    member do
      delete :remove_item     # カートから商品を削除
      post :update_quantity  # カート内の商品数を変更
    end
  end

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
  
  root to: "homes#top"

  get "up" => "rails/health#show", as: :rails_health_check
end