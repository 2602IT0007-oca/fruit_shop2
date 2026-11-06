class ApplicationController < ActionController::Base
  # Deviseのコントローラ実行時にストロングパラメータを設定
  before_action :configure_permitted_parameters, if: :devise_controller?

  # ユーザがログインしている場合、セッションのカート情報をDBのカートにマージする
  before_action :prepare_cart, if: :user_signed_in? # 追加

  # 各アクションの前に実行される。
  # 商品詳細ページ（products#show）を見た場合のみ、セッションに商品IDを記録する
  before_action :store_recent_product
  include PriceCalculations # モジュールを読み込むことで共通メソッドを全体のコントローラーで使用可能に
  
   # ログイン後の遷移先を設定
  def after_sign_in_path_for(resource)
    mypage_path(resource)
  end

  # ログアウト後の遷移先を設定
  def after_sign_out_path_for(resource)
    session.delete(:cart_merged) # 追加
    root_path
  end

  protected

  # サインアップ時に name と admin_flg を許可
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :admin_flg])
  end
     private
  # 最近見た商品をセッションに保存するメソッド
  def store_recent_product
    # 今見ているページが products コントローラーの show アクション（＝商品詳細ページ）のときだけ処理
    if params[:controller] == 'products' && params[:action] == 'show'
    product_id = params[:id].to_i  # パラメータから商品IDを取得（文字列→整数に変換）
    session[:recent_product_ids] ||= []  # セッションに recent_product_ids がなければ空配列で初期化
    session[:recent_product_ids].delete(product_id)  # 重複を防ぐために、すでにあるIDを削除
    session[:recent_product_ids].unshift(product_id) # 商品IDを配列の先頭に追加（新しい順に並べる）
    session[:recent_product_ids] = session[:recent_product_ids].take(5)  # 配列の先頭5件だけを残す（＝最大5件まで表示）
    end
  end
    def prepare_cart
     # セッションにカートがマージ済みであるか、または管理者ユーザの場合は何もしない
    return if session[:cart_merged] || current_user.admin_flg?
    # find_or_create_byは、指定した条件でレコードを検索し、存在しなければDBに新規作成するメソッド
    cart = Cart.find_or_create_by(user_id: current_user.id)
    return if !session[:cart]  # セッションのカートが空なら何もしない
    session[:cart].each do |item|
    # カート内に同じ商品がある場合は数量を更新ない場合は新規作成
      cart_item = cart.cart_items.find_or_initialize_by(product_id: item["id"])
      cart_item.quantity += item["count"].to_i # 数量を加算
      cart_item.save
    end
    session.delete(:cart)
    session[:cart_merged] = true  # セッションにマージ済みフラグを設定
  end
end