class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false    # 商品名（必須）
      t.text :description            # 商品説明
      t.integer :price, null: false  # 価格（必須）

      t.timestamps                   # 作成日時と更新日時
    end
  end
end