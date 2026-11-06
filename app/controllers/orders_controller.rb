class OrdersController < ApplicationController
  # 注文入力画面
  def new
    @order = Order.new
    @cart_items = current_user.cart.cart_items.includes(:product)  # カート内の商品情報を取得
    user_cart_calculation
  end
 
  # 注文履歴
  def index
    @orders = current_user.orders.includes(order_details: :product) # ユーザーに紐付いた注文履歴を表示
  end
 
  # 注文内容の確認画面
  def confirm
    @order = Order.new(order_params)         # フォームから送信された注文情報を取得
    @order.user = current_user               # 現在のユーザーを注文に紐付け
    @cart_items = current_user.cart.cart_items.includes(:product)  # カート内の商品情報を取得
    user_cart_calculation
 
    if @order.valid?
      @order.total_price = @cart_total       # カートの合計金額を設定
    else
      # バリデーションNGなら入力画面に戻る
      render :new and return
    end
  end
 
  # 注文登録
  def create
    @cart_items = current_user.cart.cart_items.includes(:product)  # カート内の商品情報を取得
 
    # カートが空なら注文できない
    if @cart_items.empty?
      redirect_to new_order_path, alert: "カートに商品がありません"
      return
    end
 
    user_cart_calculation
 
    @order = Order.new(order_params)
    @order.user = current_user               # ログイン中のユーザーを紐付け
    @order.total_price = @cart_total         # 合計金額はサーバー側で計算した値を使う
 
    # カートの商品を1つずつ注文明細(order_details)に入れる
    @cart_items.each do |cart_item|
      @order.order_details.build(
        product: cart_item.product,
        quantity: cart_item.quantity,
        price: cart_item.product.price
      )
    end
 
    # 注文が正常に保存できた場合
    if @order.save
      current_user.cart.cart_items.destroy_all     # 注文したのでカートを空にする
      redirect_to complete_order_path(@order)      # 注文完了ページへ遷移
    else
      redirect_to new_order_path                   # 注文入力へ戻る
    end
  end
 
  # 注文完了
  def complete
    @order = current_user.orders.includes(order_details: :product).find(params[:id])
  end
 
  private
 
  def order_params
    params.require(:order).permit(:address)
  end
end
 