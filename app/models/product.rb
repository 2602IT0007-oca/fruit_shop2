class Product < ApplicationRecord
  # 関連付け
  has_many :cart_items
  has_many :order_details
  has_many :orders, through: :order_details

  # バリデーション
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true

  # Active Storage（商品画像）
  has_one_attached :photo

  # 検索（Ransack）
  def self.ransackable_attributes(auth_object = nil)
    %w[name price]
  end

  # 関連（association）は検索に使わない
  def self.ransackable_associations(auth_object = nil)
    []
  end

  # 商品画像のサムネイルを生成
  def thumbnail
    photo.variant(resize_to_limit: [150, 150]).processed # 画像を 150x150 ピクセル以内にリサイズ
  end
end