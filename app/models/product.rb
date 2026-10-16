class Product < ApplicationRecord
    has_many :orders
    has_many :cart_items
    validates :name,presence: true, uniqueness: true
    validates :price,presence: true
    # Active Storage（商品画像）
    has_one_attached :photo

    # 商品画像のサムネイルを生成
    def thumbnail
      photo.variant(resize_to_limit: [150, 150]).processed  # 画像を 150x150 ピクセル以内にリサイズ
    end
end
